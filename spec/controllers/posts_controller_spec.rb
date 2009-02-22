require File.dirname(__FILE__) + '/../spec_helper'

describe PostsController, "as plebian" do
  fixtures :users, :posts, :topics, :edits
  before do
    login_as(:plebian)
    @post = mock_model(Post)
    @posts = [@post]
    @user = mock_model(User)
    @topic = mock_model(Topic)
    @real_topic = topics(:user)
    @forum = mock_model(Forum)
    @edit = mock_model(Edit)
    @edits = [@edit]
    @first_post = posts(:user)
    @pleban = users(:plebian)
  end
  
  it "should be able to get posts for the current user" do
    User.should_receive(:find).twice.and_return(@user)
    @user.should_receive(:update_attribute).twice
    @user.should_receive(:time_zone).at_most(4).times.and_return("Australia/Adelaide")
    @user.should_receive(:per_page).and_return(30)
    @user.should_receive(:posts).and_return(@posts)
    @posts.should_receive(:paginate).and_return(@posts)
    get 'index', :user_id => 1
  end
  
  it "should be able to start a new post" do
    Topic.should_receive(:find).and_return(@topic)
    @topic.should_receive(:last_10_posts).and_return(@posts)
    @topic.should_receive(:posts).and_return(@posts)
    @posts.should_receive(:build).and_return(@post)
    get 'new', :topic_id => 1
  end
  
  it "should be able to start a new post with a quote from another" do
    Topic.should_receive(:find).and_return(@topic)
    @topic.should_receive(:posts).and_return(@posts)
    @posts.should_receive(:build).and_return(@post)
    Post.should_receive(:find).and_return(@post)
    @post.should_receive(:text=).and_return("[quote=\"plebian\"]woot[/quote]")
    @post.should_receive(:user).and_return(@user)
    @post.should_receive(:text).and_return("[quote=\"plebian\"]woot[/quote]")
    get 'reply', { :id => posts(:user).id, :topic_id => 1 }
    response.should render_template("new")
  end
  
  
  it "should be able to edit a post" do
    Post.should_receive(:find).and_return(@post)
    @post.should_receive(:belongs_to?).and_return(true)
    get 'edit', :id => @first_post.id
  end
  
  it "shouldn't be able to edit a post that doesn't belong to them" do
    Post.should_receive(:find).twice.and_return(@post)
    @post.should_receive(:belongs_to?).and_return(false)
    get 'edit', { :id => posts(:admin).id }
    flash[:notice].should_not be_nil
    response.should redirect_to(forums_path)
  end
  
  it "should be able to update a post" do
    Post.should_receive(:find).and_return(@post)
    @post.should_receive(:belongs_to?).and_return(true)
    @post.should_receive(:update_attributes).and_return(true)
    @post.should_receive(:topic).and_return(@topic)
    @post.stub!(:text)
    @post.should_receive(:forum).and_return(@forum)
    @post.should_receive(:text_changed?).and_return(true)
    @post.should_receive(:edits).and_return(@edits)
    @edits.should_receive(:create).and_return(@edit)
    @post.should_receive(:update_attribute).and_return(@user)
    @post.should_receive(:page_for).and_return(1)
    put 'update', :id => @first_post.id, :post => { :text => "Hooray!" }
    flash[:notice].should_not be_nil
  end
  
  it "shouldn't be able to update a post that doesn't exist" do
    Post.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
    put 'update', :id => 1234567890, :post => { :text => "" }
  end
  
  it "should not be able to update a post with invalid data" do
    Post.should_receive(:find).and_return(@post)
    @post.should_receive(:belongs_to?).and_return(true)
    @post.should_receive(:update_attributes).and_return(false)
    @post.should_receive(:topic).and_return(@topic)
    @post.stub!(:text)
    put 'update', :id => @first_post.id, :post => { :text => "" }
    flash[:notice].should eql("This post could not be updated.")
  end
  
  it "should not be able to edit a post that does not exist" do
    Post.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
    get 'edit', :id => 'post'
    flash[:notice].should eql("The post you were looking for could not be found.")
    response.should redirect_to(forums_path)
  end
  
  it "should be able to create a post" do
    User.should_receive(:find).and_return(@user)
    @user.stub!(:per_page).and_return(30)
    @user.stub!(:update_attribute)
    @user.stub!(:time_zone)
    Topic.should_receive(:find).with("1", :include => :posts).twice.and_return(@topic)
    @topic.should_receive(:posts).at_most(3).times.and_return(@posts)
    @posts.should_receive(:find).with(:all, :order => "id DESC", :limit => 10)
    @posts.should_receive(:build).and_return(@post)
    @post.should_receive(:save).and_return(true)
    @post.should_receive(:forum).twice.and_return(@forum)
    @post.should_receive(:topic).and_return(@topic)
    @topic.should_receive(:set_last_post).and_return(true)
    @post.should_receive(:page_for).and_return(1)
    post 'create', { :post => { :text => "This is a new post" }, :topic_id => 1 }
    flash[:notice].should eql("Post has been created.")
    response.should redirect_to(forum_topic_path(@post.forum, @post.topic) + "/1#post_#{@post.id}")
  end
  
  it "should not be able to create an invalid post" do
    Topic.should_receive(:find).with("1", :include => :posts).twice.and_return(@topic)
    @topic.should_receive(:posts).twice.and_return(@posts)
    @posts.should_receive(:find).with(:all, :order => "id DESC", :limit => 10)
    @posts.should_receive(:build).and_return(@post)
    @post.should_receive(:save).and_return(false)
    post 'create', {:post => { :text => "This is a new post" }, :topic_id => 1 }
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
    @post.should_receive(:belongs_to?).and_return(true)
    delete 'destroy', :id => @first_post.id
    response.should redirect_to(forum_topic_path(@post.forum, @post.topic))
    flash[:notice].should eql("Post was deleted.")
  end
  
  it "should be able to destroy a post, and the topic" do
    Post.should_receive(:find).and_return(@post)
    @post.should_receive(:destroy).and_return(@post)
    @post.should_receive(:topic).twice.and_return(@topic)
    @post.should_receive(:forum).twice.and_return(@forum)
    @topic.should_receive(:posts).and_return(@posts)
    @posts.should_receive(:size).and_return(0)
    @topic.should_receive(:destroy).and_return(@topic)
    @post.should_receive(:belongs_to?).and_return(true)
    delete 'destroy', :id => 1
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
