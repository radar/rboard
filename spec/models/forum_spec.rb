require File.dirname(__FILE__) + '/../spec_helper'
describe Forum, "creation" do
  fixtures :forums, :categories
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
  fixtures :forums, :topics, :posts, :users, :categories

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

  it "should be able to find the last post" do
    # We have to reload the object here because of how valid_topic_for works
    @everybody.reload
    @everybody.last_post.should_not be_nil

    @sub_of_everybody.last_post.should be_nil
  end

  it "should be able to find the forum of the last post" do
    @everybody.last_post_forum.should eql(nil)
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
