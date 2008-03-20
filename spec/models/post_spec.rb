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
  fixtures :posts, :topics, :forums
  
  before do
    @post = posts(:first)
  end
  it "should be able to find its forum" do
    @post.forum.should eql(forums(:everybody))
  end
  
  it "should be able to update a forum with the proper last post" do
    @new_post = Post.new(:topic_id => 1, :user_id => 1, :text => "Woot")
    @new_post.forum.last_post_id.should be_nil
    @new_post.save
    @new_post.forum.last_post_id.should eql(@new_post.id)
  end
  
  it "should update the forum and its ancestors with the latest post" do 
    @new_topic = Topic.new(:forum_id => 4, :user_id => 1, :subject => "Hello")
    @new_post = @new_topic.posts.build(:topic_id => 1, :user_id => 1, :text => "Woot")
    @new_post.forum.last_post_id.should be_nil
    @new_topic.save.should be_true
    @new_post.forum.last_post_id.should eql(@new_post.id)
    @new_post.forum.ancestors.each { |ancestor| ancestor.last_post_id.should eql(@new_post.id) }
  end
end

