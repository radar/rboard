require File.dirname(__FILE__) + '/../spec_helper'
describe Post, "validations" do
  fixtures :posts
  before(:each) do
    @post = posts(:invalid)
  end
  
  it "should validate the length of text" do
    @post.text = "Shr"
    @post.save.should be_false
    @post.errors_on(:text).should_not be_empty
    @post.text = nil
    @post.save.should be_false
    @post.errors_on(:text).should_not be_empty
  end
  
end
describe Post, "general" do
  fixtures :posts, :topics, :forums, :users
  
  before do
    @post = posts(:user)
    @post_2 = posts(:user_2)
    @post_3 = posts(:user_3)
    @lone_post = posts(:moderator)
    @topic = topics(:user)
    @sub_topic = topics(:user_3)
    @plebian = users(:plebian)
    @administrator = users(:administrator)
  end
  
  it "should be able to find its forum" do
    @post.forum.should eql(forums(:everybody))
  end
  
  it "should be able to update a forum with the proper last post" do
    # Because we limit users, by default, to one post per minute
    two_minutes_into_the_future = Time.now + 2.minutes
    Time.stub!(:now).and_return(two_minutes_into_the_future)
    @new_post = Post.new(:topic => topics(:user), :user => users(:plebian), :text => "Woot")
    @new_post.forum.last_post.should eql(posts(:user))
    @new_post.save
    @new_post.forum.last_post.should eql(@new_post)
  end

  it "should update the forum and its ancestors with the latest post" do
    # Because we limit users, by default, to one post per minute
    two_minutes_into_the_future = Time.now + 2.minutes
    Time.stub!(:now).and_return(two_minutes_into_the_future)
    @sub_topic.forum.sub?.should be_true
    @new_post = @sub_topic.posts.build(:user => users(:plebian), :text => "Woot")
    @new_post.forum.last_post.should eql(nil)
    @sub_topic.save.should be_true
    @sub_topic.posts.should_not be_empty
    @new_post.forum.sub?.should be_true
    @new_post.forum.last_post.should eql(@new_post)
    @new_post.forum.ancestors.each do |ancestor| 
      ancestor.last_post.should eql(@new_post)
      ancestor.last_post.forum.should eql(@new_post.forum)
    end
  end
  
  it "should be able to find the latest post" do
    @post.destroy
    @post.find_latest_post
  end
  
  it "should be able to destroy a lone post and set the last post to nil" do
    @lone_post.destroy
    @lone_post.find_latest_post
  end
  
  it "should belong to a user" do
    @post.belongs_to?(@plebian).should be_true
    @post.belongs_to?(@administrator).should be_false
  end
 
  
  it "should not be able to be flooded" do
    @sub_topic.posts.build(:user => users(:plebian), :text => "Woot")
    @sub_topic.save.should be_true
    other_post = @sub_topic.posts.build(:user => users(:plebian), :text => "Woot")
    other_post.save.should be_false
  end
  
end

