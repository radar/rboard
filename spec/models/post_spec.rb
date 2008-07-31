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
  end
  
  it "should be able to find its forum" do
    @post.forum.should eql(forums(:everybody))
  end
  
  it "should be able to update a forum with the proper last post" do
    @new_post = Post.new(:topic => topics(:user), :user => users(:plebian), :text => "Woot")
    @new_post.forum.last_post.should eql(posts(:user))
    @new_post.save
    @new_post.forum.last_post.should eql(@new_post)
  end


  
  it "should update the forum and its ancestors with the latest post" do 
    @new_topic = Topic.new(:forum => forums(:sub_of_everybody), :user => users(:plebian), :subject => "Hello")
    @new_post = @new_topic.posts.build(:topic => topics(:user), :user => users(:plebian), :text => "Woot")
    @new_post.forum.last_post.should eql(posts(:user))
    @new_topic.save.should be_true
    @new_post.forum.last_post.should eql(@new_post)
    @new_post.forum.ancestors.each do |ancestor| 
      ancestor.last_post.should eql(@new_post)
      ancestor.last_post.forum.should eql(@new_post.forum)
    end
  end
end

