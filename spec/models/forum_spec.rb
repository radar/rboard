require File.dirname(__FILE__) + '/../spec_helper'
describe Forum, "creation" do
  before(:each) do
    @invalid = Forum.new
  end

  it "validation checks" do
    #title cannot be empty
    @invalid.save.should be_false
    @invalid.errors_on(:title).should_not be_empty

    #description cannot be empty
    @invalid.save.should be_false
    @invalid.errors_on(:description).should_not be_empty
  end

end

describe Forum, "in general" do

  before do
    setup_user_base
    @everybody = Forum.make(:public)
    @sub_of_everybody = Forum.make(:sub_of_public)
    @sub_of_sub_of_everybody = Forum.make(:sub_of_sub_of_public)
    @admins_only = Forum.make(:admins_only)
    @moderators_only = Forum.make(:moderators_only)
    @user_topic = valid_topic_for(@everybody)
    @user_topic_2 = valid_topic_for(@everybody)
  end

  it "should be able to find all descendants of a forum" do
    @everybody.descendants.size.should eql(2)
    @everybody.descendants.should eql([@sub_of_sub_of_everybody, @sub_of_everybody])
    @sub_of_everybody.descendants.size.should eql(1)
    @sub_of_everybody.descendants.should eql([@sub_of_sub_of_everybody])
    @sub_of_sub_of_everybody.descendants.size.should eql(0)
    @sub_of_sub_of_everybody.descendants.should be_empty
  end

  it "should be able to find all the root forums" do
    @root_forums = Forum.without_parent
    @root_forums.size.should eql(3)
  end

  it "should be able to find the root of any forum, the highest ancestor" do
    @everybody.root.should eql(@everybody)
    @sub_of_everybody.root.should eql(@everybody)
    @sub_of_sub_of_everybody.root.should eql(@everybody)
  end

  it "should be able to show the string version of the forum" do
    @everybody.to_s.should eql("Public Forum")
  end

  it "should be able to get all the topics in order" do
    @everybody.topics.sort_by(&:created_at).should eql([@user_topic, @user_topic_2])
  end

  it "should be able to find the ancestors for any given forum" do
    @sub_of_everybody.ancestors.should eql([@everybody])
  end

  it "should return true if the forum is a subforum of another" do
    @everybody.sub?.should eql(false)
    @sub_of_everybody.sub?.should eql(true)
  end
end

describe Forum, "last post" do
  before do
    setup_user_base
    @everybody = Forum.make(:public)
    @sub_of_everybody = Forum.make(:sub_of_public)
    @user_topic = valid_topic_for(@everybody)
    @user_topic_2 = valid_topic_for(@everybody)
    # We have to reload the object here because of how valid_topic_for works
    @everybody.reload
  end

  it "should be able to find the last post" do
    @everybody.last_post.should_not be_nil
    @sub_of_everybody.last_post.should be_nil
  end

  it "should be able to find the forum of the last post" do
    @everybody.last_post_forum.should eql(nil)
  end

  context "when managing posts" do
    before do
      @previous_time = @everybody.posts.first.created_at
      @shady_topic = valid_topic_for(@everybody, 2)
      @normal_post, @conspicuous_post = @shady_topic.posts
      @normal_post.update_attribute(:created_at, @previous_time + 6.minutes)
      @conspicuous_post.update_attribute(:created_at, @previous_time + 12.minutes)

      @everybody.reload
      @everybody.topics.count.should == 3
      @everybody.posts.count.should == 4
    end
    
    it "should be able to determine the latest post" do
      @everybody.last_post.should == @conspicuous_post
    end
    
    it "should re-determine the latest post when one is deleted" do
      @conspicuous_post.destroy
      @everybody.reload
      @everybody.last_post.should == @normal_post
    end

    it "should re-determine the latest post when a topic is deleted" do
      @shady_topic.destroy
      @everybody.reload
      @everybody.topics.count.should == 2
      @everybody.posts.count.should == 2
      @everybody.last_post.should_not == @conspicuous_post
      @everybody.last_post.created_at.should == @previous_time
    end
  end
end
