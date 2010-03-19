require File.dirname(__FILE__) + '/../spec_helper'
describe Post, "validations" do
  before(:each) do
    @post = Post.new
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

  before do
    setup_user_base
    @public = Forum.make(:public)
    @sub_of_public = Forum.make(:sub_of_public)
    @topic = valid_topic_for(@public)
    @sub_topic = valid_topic_for(@sub_of_public)
    @post = @topic.posts.first
    @sub_post = @sub_topic.posts.first
    @registered_user = User("registered_user")
    @administrator = User("administrator")
    @ip = Ip.make(:localhost)
  end

  it "should be able to find its forum" do
    @post.forum.should eql(@public)
  end

  it "should be able to update a forum with the proper last post" do
    # Because we limit users, by default, to one post per minute
    two_minutes_into_the_future = Time.now + 2.minutes
    Time.stub!(:now).and_return(two_minutes_into_the_future)
    @new_post = @topic.posts.build(:user => @registered_user, :text => "Woot", :ip => @ip)
    @new_post.forum.last_post.should eql(@sub_post)
    @new_post.save
    @new_post.forum.last_post.should eql(@new_post)
  end

  it "should update the forum and its ancestors with the latest post" do
    # Because we limit users, by default, to one post per minute
    two_minutes_into_the_future = Time.now + 2.minutes
    Time.stub!(:now).and_return(two_minutes_into_the_future)
    @sub_topic.forum.sub?.should be_true
    @new_post = @sub_topic.posts.build(:user => @registered_user, :text => "Woot", :ip => @ip)
    @new_post.forum.last_post.should eql(@sub_post)
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
    @sub_post.destroy
    @sub_post.find_latest_post
  end

  it "should belong to a user" do
    @post.belongs_to?(@administrator).should be_true
    @post.belongs_to?(@registered_user).should be_false
  end


  it "should not be able to be flooded" do
    TIME_BETWEEN_POSTS = 1.minute
    @sub_topic.posts.build(:user => @registered_user, :text => "Woot", :ip => @ip)
    @sub_topic.save.should be_true
    other_post = @sub_topic.posts.build(:user => @registered_user, :text => "Woot", :ip => @ip)
    other_post.save.should be_false
  end

end

