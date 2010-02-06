require File.dirname(__FILE__) + '/../spec_helper'

describe PostsController, "as plebian" do

  before do
    setup_user_base
    setup_forums
    login_as(:registered_user)
    @registered_user = User("registered_user")
    @admin_forum = Forum("Admins Only")
    @admin_topic = @admin_forum.topics.first
    @everybody = Forum("Public Forum")
    @topic = @everybody.topics.first

    # Post is owned by the registered_user for this.
    @post = @topic.posts.first
    @post.user = @registered_user
    @post.save!

    @other_user_topic = @everybody.topics.last
  end

  it "should be able to start a new post" do
    get 'new', :topic_id => @topic.id
    response.should render_template("new")
  end

  it "should be able to edit a post" do
    get 'edit', :id => @post.id, :topic_id => @topic.id
    response.should render_template("edit")
  end

  it "shouldn't be able to edit a post that doesn't belong to them" do
    get 'edit', { :id => @admin_topic.posts.first.id, :topic_id => @topic.id }
    flash[:notice].should eql(t(:Cannot_edit_post))
    response.should redirect_to(forums_path)
  end

  it "should be able to update a post" do
    put 'update', :id => @post.id, :post => { :text => "Hooray!" }, :topic_id => @topic.id
    flash[:notice].should eql(t(:updated, :thing => "post"))
  end

  it "shouldn't be able to update a post that doesn't exist" do
    put 'update', :id => 1234567890, :post => { :text => "" }, :topic_id => @topic.id
    response.should redirect_to(forums_path)
    flash[:notice].should eql(t(:not_found, :thing => "post"))
  end

  it "should not be able to update a post with invalid data" do
    put 'update', :id => @post.id, :post => { :text => "" }, :topic_id => @topic.id
    response.should render_template("edit")
  end

  it "should not be able to edit a post that does not exist" do
    get 'edit', :id => 'post', :topic_id => @topic.id
    flash[:notice].should eql(t(:not_found, :thing => "post"))
    response.should redirect_to(forums_path)
  end

  it "should be able to create a post" do
    two_minutes_into_the_future = Time.now + 2.minutes
    Time.stub!(:now).and_return(two_minutes_into_the_future)
    post 'create', { :post => { :text => "This is a new post" }, :topic_id => @topic.id }
    @post_id = Post.last.id
    flash[:notice].should eql(t(:created, :thing => "Post"))
    response.should redirect_to(forum_topic_path(@everybody, @topic) + "/1#post_#{@post_id}")
  end

  it "should not be able to create an invalid post" do
    post 'create', {:post => { :text => ""  }, :topic_id => @topic.id }
    response.should render_template("new")
  end

  it "should be able to destroy a post, but not the topic" do
    @post.stub!(:forum).and_return(@everybody)
    @post.stub!(:topic).and_return(@topic)
    delete 'destroy', :id => @post.id, :topic_id => @topic.id
    response.should redirect_to(forum_topic_path(@post.forum, @post.topic))
    flash[:notice].should eql(t(:deleted, :thing => "post"))
  end

  it "should be able to destroy a post, and the topic if they own the post" do
    # Ensure there's only one post left in this topic.
    while @topic.posts.count != 1
      @topic.posts.last.destroy
      @topic.reload
    end

    # Ensure that the registered_user still owns this post.
    @post = @topic.posts.first
    @post.user = User(:registered_user)
    @post.save!

    delete 'destroy', :id => @post.to_param, :topic_id => @topic.to_param
    flash[:notice].should eql(t(:deleted, :thing => "post") + t(:topic_too))
    response.should redirect_to(forum_path(@everybody))
  end

  it "should not be able to destroy a post, and the topic if they do not own the post" do
    @post.user = User(:administrator)
    @post.save!
    delete 'destroy', :id => @topic.posts.first.to_param, :topic_id => @topic.to_param
    response.should redirect_to(forums_path)
    flash[:notice].should eql(t(:Cannot_edit_post))
  end

  it "should not be able to destroy a post that does not exist" do
    Post.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
    delete 'destroy', :id => 1234567890
    response.should redirect_to(forums_path)
    flash[:notice].should eql(t(:not_found, :thing => "post"))
  end

end
