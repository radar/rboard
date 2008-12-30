require File.dirname(__FILE__) + '/../spec_helper'
describe Forum, "creation" do
  fixtures :forums
  before(:each) do
    @invalid = forums(:invalid)
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
  fixtures :forums, :topics, :posts, :users, :user_levels
  
  before do
    @everybody = forums(:everybody)
    @sub_of_everybody = forums(:sub_of_everybody)
    @sub_of_sub_of_everybody = forums(:sub_of_sub_of_everybody)
    @admins_only = forums(:admins_only)
    @moderators_only = forums(:moderators_only)
    @user_topic = topics(:user)
    @user_topic_2 = topics(:user_2)
  end
  
  it "should be able to find the last post" do
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
    @root_forums = Forum.find_all_without_parent
    @root_forums.size.should eql(4)
  end
  
  it "should be able to find the root of any forum, the highest ancestor" do
    @everybody.root.should eql(@everybody)
    @sub_of_everybody.root.should eql(@everybody)
    @sub_of_sub_of_everybody.root.should eql(@everybody)
  end
  
  it "should be able to show the string version of the forum" do
    @everybody.to_s.should eql("General Discussion!")
  end
  
  it "should be able to get all the topics in order" do
    @everybody.topics.should eql([@user_topic_2, @user_topic])
  end
  
  it "should be able to find the ancestors for any given forum" do
    @sub_of_everybody.ancestors.should eql([@everybody])
  end
  
  it "should return true if the forum is a subforum of another" do
    @everybody.sub?.should eql(false)
    @sub_of_everybody.sub?.should eql(true)
  end
  
  it "should be able to determine if a topic is visible by a user" do
    @administrator = users(:administrator)
    @moderator = users(:moderator)
    @plebian = users(:plebian)
    
    @everybody.viewable?(:false).should be_true
    @everybody.viewable?(@administrator).should be_true
    @everybody.viewable?(@moderator).should be_true
    @everybody.viewable?(@plebian).should be_true

    @moderators_only.viewable?(:false).should be_false
    @moderators_only.viewable?(@administrator).should be_true
    @moderators_only.viewable?(@moderator).should be_true
    @moderators_only.viewable?(@plebian).should be_false

    @admins_only.viewable?(:false).should be_false
    @admins_only.viewable?(@administrator).should be_true
    @admins_only.viewable?(@moderator).should be_false
    @admins_only.viewable?(@plebian).should be_false
  end
  
  it "should be able to determine if a topic is creatable by a user" do
    @administrator = users(:administrator)
    @moderator = users(:moderator)
    @plebian = users(:plebian)
    
    @everybody.topics_creatable_by?(:false).should be_true
    @everybody.topics_creatable_by?(@administrator).should be_true
    @everybody.topics_creatable_by?(@moderator).should be_true
    @everybody.topics_creatable_by?(@plebian).should be_true
    
    @moderators_only.topics_creatable_by?(:false).should be_false
    @moderators_only.topics_creatable_by?(@administrator).should be_true
    @moderators_only.topics_creatable_by?(@moderator).should be_true
    @moderators_only.topics_creatable_by?(@plebian).should be_false
    
    @admins_only.topics_creatable_by?(:false).should be_false
    @admins_only.topics_creatable_by?(@administrator).should be_true
    @admins_only.topics_creatable_by?(@moderator).should be_false
    @admins_only.topics_creatable_by?(@plebian).should be_false
  end
  
  it "should set the category's viewable status when saved or destroyed" do
    @everybody.category.is_visible_to.should eql(user_levels(:user))
    @everybody.save
    @everybody.category.is_visible_to.should eql(user_levels(:administrator))
    @admins_only.destroy
    @everybody.reload
    @everybody.category.is_visible_to.should eql(user_levels(:moderator))
  end
    
end
