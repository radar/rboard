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
    @topic = topics(:user)
    @sub_topic = topics(:user_3)
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
    @sub_topic.forum.sub?.should be_true
    @new_post = @sub_topic.posts.build(:user => users(:plebian), :text => "Woot")
    @new_post.forum.last_post.should eql(nil)
    @sub_topic.save.should be_true
    @new_post.forum.sub?.should be_true
    @new_post.forum.last_post.should eql(@new_post)
    @new_post.forum.ancestors.each do |ancestor| 
      ancestor.last_post.should eql(@new_post)
      ancestor.last_post.forum.should eql(@new_post.forum)
    end
  end
  
  # it "should update the forum and its ancestors with the latest post when an existing post is destroyed" do
  #   @post_2.forum.last_post.should eql(@post)
  #   @post.destroy
  #   @post_2.forum.reload
  #   @post_2.forum.last_post.should eql(@post_2)
  #   @post_2.forum.ancestors.map { |forum| forum.last_post.should eql(@post_2) }
  #   @post_2.destroy
  #   @post_3.forum.reload
  #   @post_3.forum.last_post.should eql(@post_3)
  #   @post_2.forum.ancestors.map { |forum| forum.last_post.should eql(@post_3) }
  # end
  
end

