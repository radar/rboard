require File.dirname(__FILE__) + '/../spec_helper'

describe PostsController, "as plebian" do
  fixtures :users, :forums, :posts, :topics, :edits, :permissions, :groups, :group_users
  before do
    login_as(:plebian)
    @plebian = users(:plebian)
    @user_topic = topics(:user)
    @topic = mock_model(Topic)
    @post = mock_model(Post)
    @posts = [@post]
    @user = mock_model(User)
    @first_post = posts(:user)
    @everybody = topics(:user)
  end

  it "should be able to get posts for the current user" do
    get 'index', :user_id => @plebian.id
    response.should render_template("index")
  end

  it "should be able to start a new post" do
    get 'new', :topic_id => @user_topic.id
    response.should render_template("new")
  end

  it "should be able to start a new post with a quote from another" do
    Topic.should_receive(:find).and_return(@topic)
    @topic.should_receive(:posts).and_return(@posts)
    @posts.should_receive(:build).and_return(@post)
    Post.should_receive(:find).and_return(@post)
    @post.should_receive(:text=).and_return("[quote=\"plebian\"]woot[/quote]")
    @post.should_receive(:user).and_return(@user)
    @post.should_receive(:text).and_return("[quote=\"plebian\"]woot[/quote]")
    get 'reply', { :id => posts(:user).id, :topic_id => topics(:user).id }
    response.should render_template("new")
  end


  it "should be able to edit a post" do
    get 'edit', :id => @first_post.id, :topic_id => @everybody.id
    response.should render_template("edit")
  end

  it "shouldn't be able to edit a post that doesn't belong to them" do
    get 'edit', { :id => posts(:admin).id }, :topic_id => @everybody.id
    flash[:notice].should eql(t(:Cannot_edit_post))
    response.should redirect_to(forums_path)
  end

  it "should be able to update a post" do
    put 'update', :id => @first_post.id, :post => { :text => "Hooray!" }, :topic_id => @everybody.id
    flash[:notice].should eql(t(:updated, :thing => "post"))
  end

  it "shouldn't be able to update a post that doesn't exist" do
    Post.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
    put 'update', :id => 1234567890, :post => { :text => "" }, :topic_id => @everybody.id
    response.should redirect_to(forums_path)
    flash[:notice].should eql(t(:not_found, :thing => "post"))
  end

  it "should not be able to update a post with invalid data" do
    put 'update', :id => @first_post.id, :post => { :text => "" }, :topic_id => @everybody.id
    response.should render_template("edit")
  end

  it "should not be able to edit a post that does not exist" do
    get 'edit', :id => 'post', :topic_id => @everybody.id
    flash[:notice].should eql(t(:not_found, :thing => "post"))
    response.should redirect_to(forums_path)
  end

  it "should be able to create a post" do
    two_minutes_into_the_future = Time.now + 2.minutes
    Time.stub!(:now).and_return(two_minutes_into_the_future)
    post 'create', { :post => { :text => "This is a new post" }, :topic_id => topics(:user).id }
    @post_id = Post.last.id
    flash[:notice].should eql(t(:created, :thing => "post"))
    response.should redirect_to(forum_topic_path(forums(:everybody), topics(:user)) + "/1#post_#{@post_id}")
  end

  it "should not be able to create an invalid post" do
    post 'create', {:post => { :text => ""  }, :topic_id => topics(:user).id }
    response.should render_template("new")
  end

  it "should be able to destroy a post, but not the topic" do
    @post.stub!(:forum).and_return(forums(:everybody))
    @post.stub!(:topic).and_return(topics(:user))
    delete 'destroy', :id => @first_post.id, :topic_id => @everybody.id
    response.should redirect_to(forum_topic_path(@post.forum, @post.topic))
    flash[:notice].should eql(t(:deleted, :thing => "post"))
  end

  it "should be able to destroy a post, and the topic" do
    @post.stub!(:forum).and_return(forums(:everybody))
    @post.stub!(:belongs_to?).and_return(true)
    Post.should_receive(:find).and_return(@post)
    @post.should_receive(:topic).twice.and_return(@topic)
    @topic.should_receive(:posts).and_return(@posts)
    @post.should_receive(:destroy)
    @topic.should_receive(:destroy)
    @posts.should_receive(:size).and_return(0)
    delete 'destroy', :id => @first_post.to_param, :topic_id => @everybody.to_param
    response.should redirect_to(forum_path(@post.forum))
    flash[:notice].should eql(t(:deleted, :thing => "post") + t(:topic_too))
  end

  it "should not be able to destroy a post that does not exist" do
    Post.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
    delete 'destroy', :id => 1234567890
    response.should redirect_to(forums_path)
    flash[:notice].should eql(t(:not_found, :thing => "post"))
  end

end
