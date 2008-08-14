require File.dirname(__FILE__) + '/../spec_helper'

describe PostsController, "as plebian" do
  fixtures :users, :posts, :topics
  before do
    login_as(:plebian)
    @post = mock("post")
    @posts = [@post]
    @user = mock("user")
    @topic = mock("topic")
    @real_topic = topics(:user)
    @forum = mock("forum")
    @first_post = posts(:user)
  end
  it "should be able to edit a post" do
    Post.should_receive(:find).twice.and_return(@post)
    @post.should_receive(:user).and_return(@user)
    get 'edit', :id => @first_post.id
  end
  
  it "shouldn't be able to edit a post that doesn't belong to them" do
    Post.should_receive(:find).at_least(3).times.and_return(@post)
    @post.should_receive(:user).and_return(@user)
    get 'edit', { :id => posts(:admin).id }
    flash[:notice].should_not be_nil
    response.should redirect_to(forums_path)
  end
  
  it "should be able to update a post" do
    Post.should_receive(:find).and_return(@post)
    @post.should_receive(:update_attributes).and_return(true)
    put 'update', :id => @first_post.id, :post => { }
    flash[:notice].should_not be_nil
  end
  
  it "shouldn't be able to update a post that doesn't exist" do
    Post.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
    put 'update', :id => 1234567890, :post => { :text => "" }
  end
  
  it "should not be able to update a post with invalid data" do
    Post.should_receive(:find).and_return(@post)
    @post.should_receive(:update_attributes).and_return(false)
    put 'update', :id => @first_post.id, :post => { :text => "" }
    flash[:notice].should eql("This post could not be updated.")
  end
  
  it "should not be able to edit any body else's post" do
    Post.should_receive(:find).twice.and_return(@post)
    @post.should_receive(:user).and_return(users(:moderator))
    get 'edit', :id => @first_post.id
    flash[:notice].should eql("You do not own that post.")
    response.should redirect_to(forums_path)
  end
  
  it "should not be able to edit a post that does not exist" do
    Post.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
    get 'edit', :id => 'post'
    flash[:notice].should eql("The post you were looking for could not be found.")
    response.should redirect_to(forums_path)
  end
  
  it "should be able to create a post" do
    Topic.should_receive(:find).with(topics(:user).id.to_s, :include => :posts).and_return(@topic)
    @topic.should_receive(:posts).at_most(3).times.and_return(@posts)
    @posts.should_receive(:find).with(:all, :order => "id DESC", :limit => 10)
    @posts.should_receive(:build).and_return(@post)
    @post.should_receive(:save).and_return(true)
    @post.should_receive(:forum).twice.and_return(@forum)
    @post.should_receive(:topic).and_return(@topic)
    @topic.should_receive(:update_attribute).with("last_post_id", @post.id).and_return(true)
    post 'create', {:post => { :text => "This is a new post" }, :topic_id => topics(:user).id }
    flash[:notice].should eql("Post has been created.")
    response.should redirect_to(forum_topic_path(@post.forum, @post.topic, :page => 1))
  end
  
  it "should not be able to create an invalid post" do
    Topic.should_receive(:find).with(topics(:user).id.to_s, :include => :posts).and_return(@topic)
    @topic.should_receive(:posts).twice.and_return(@posts)
    @posts.should_receive(:find).with(:all, :order => "id DESC", :limit => 10)
    @posts.should_receive(:build).and_return(@post)
    @post.should_receive(:save).and_return(false)
    post 'create', {:post => { :text => "This is a new post" }, :topic_id => topics(:user).id }
    flash[:notice].should eql("This post could not be created.")
    response.should render_template("new")
  end
  
  it "should be able to destroy a post, but not the topic" do
    Post.should_receive(:find).and_return(@post)
    @post.should_receive(:destroy).and_return(@post)
    @post.should_receive(:topic).at_least(3).times.and_return(@topic)
    @post.should_receive(:forum).twice.and_return(@forum)
    @topic.should_receive(:posts).and_return(@posts)
    @posts.should_receive(:size).and_return(1)
    @topic.should_not_receive(:destroy)
    delete 'destroy', :id => @first_post.id
    response.should redirect_to(forum_topic_path(@post.forum, @post.topic))
    flash[:notice].should eql("Post was deleted.")
  end
  
  it "should be able to destroy a post, and the topic" do
    Post.should_receive(:find).twice.and_return(@post)
    @post.should_receive(:destroy).and_return(@post)
    @post.should_receive(:topic).twice.and_return(@topic)
    @post.should_receive(:forum).twice.and_return(@forum)
    @topic.should_receive(:posts).and_return(@posts)
    @posts.should_receive(:size).and_return(0)
    @topic.should_receive(:destroy).and_return(@topic)
    delete 'destroy', :id => posts(:admin).id
    response.should redirect_to(forum_path(@post.forum))
    flash[:notice].should eql("Post was deleted. This was the only post in the topic, so topic was deleted also.")
  end
  
  it "should not be able to destroy a post that does not exist" do
    Post.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
    delete 'destroy', :id => 1234567890
    response.should redirect_to(forums_path)
    flash[:notice].should eql("The post you were looking for could not be found.")
  end
    
end
