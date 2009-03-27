require File.dirname(__FILE__) + '/../spec_helper'
describe TopicsController do
  fixtures :users, :forums, :topics, :posts, :group_users, :groups, :permissions

  before do
    @topic = mock_model(Topic)
    @topics = [@topic]
    @post = mock_model(Post)
    @posts = [@post]
    @forum = mock_model(Forum)
    @forums = [@forum]
    @user = mock_model(User)
    @users = [@user]
    @subscription = mock_model(Subscription)
    @subscriptions = [@subscription]
    @admin_forum = forums(:admins_only)
    @everybody = forums(:everybody)
    @admin_topic = topics(:admin)
    @post = @admin_topic.posts.first
  end

 
  def find_forum
    Forum.should_receive(:find).and_return(@forum)
  end
  
  def forum_not_viewable_aftermath
    response.should redirect_to(root_path)
    flash[:notice].should eql(I18n.t(:not_allowed_to_view_topics))
  end
  
  def topic_does_not_belong
    @forum.should_receive(:topics).and_return(@topics)
    @topics.should_receive(:find).and_return(@topic)
    @topic.should_receive(:belongs_to?).and_return(false)
  end
  
  
  describe TopicsController, "for not logged in user" do
    it "should check to see if a user is logged in before creating a new topic" do
      get 'new', { :forum_id => forums(:admins_only).id }
      response.should redirect_to('login')
      flash[:notice].should eql("You must be logged in to do that.")
    end
    
    it "should not show a restricted topic" do
      Forum.should_receive(:find).and_return(@forum)
      get 'show', { :id => @admin_topic.id, :forum_id => @admin_forum.id }
      response.should redirect_to(root_path)
      flash[:notice].should eql("You are not allowed to view topics in that forum.")
    end
  end  

  describe TopicsController, "for logged in plebian" do
    before do
      login_as(:plebian)
      @user = users(:plebian)
    end
    
    it "should redirect to the forums show action if index is requested" do
      find_forum
      get 'index', :forum_id => @everybody.id
      response.should redirect_to(forum_path(@forum))
    end
  
    it "should stop a user from being able to create a topic in a restricted forum" do
      get 'new', { :forum_id => @admin_forum.id }
      forum_not_viewable_aftermath
    end
    
    it "should not create a topic if a user is not allowed" do
      find_forum
      post 'create', { :topic => { :subject => "Test!" }, :post => { :text => "Testing!" }, :forum_id => @admin_forum.id }
      forum_not_viewable_aftermath
    end
    
    it "should not be able to see a restricted topic" do
      find_forum
      get 'show', { :id => @admin_topic.id, :forum_id => @admin_forum.id }
      forum_not_viewable_aftermath
    end
    
    it "should not be able to see topics that do not exist" do
      find_forum
      @forum.should_receive(:topics).and_return(@topics)
      @topics.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      get 'show', { :forum_id => @everybody.id, :id => 123456789 }
      flash[:notice].should eql(I18n.t(:topic_not_found))
      response.should redirect_to(forums_path)
    end
    
    it "should not be able to edit a restricted topic" do
      find_forum
      get 'edit', { :forum_id => @admin_forum.id, :id => 1 }
      forum_not_viewable_aftermath
    end
    
    it "should not be able to update a restricted topic" do
      find_forum
      put 'update', { :forum_id => @admin_forum.id, :id => 1 }
      forum_not_viewable_aftermath
    end
    
    it "should not be able to edit a topic that is not theirs" do
      find_forum
      topic_does_not_belong
      @topic.should_receive(:posts).and_return(@posts)
      get 'edit', { :forum_id => @everybody.id, :id => 2 }
      flash[:notice].should eql(t(:not_allowed_to_edit_topic))
      response.should redirect_to(forum_topic_path(@forum, @topic))
    end
    
    it "should not be able to update a topic that is not theirs" do
      find_forum
      topic_does_not_belong
      @topic.should_not_receive(:update_attributes)
      put 'update', { :forum_id => @everybody.id, :id => 2, :topic => { :subject => "Subject" } }
      flash[:notice].should eql(t(:not_allowed_to_edit_topic))
      response.should redirect_to(forum_topic_path(@forum, @topic))
    end
    
  end
  
  describe TopicsController, "for logged in administrator" do
    before do
      login_as(:administrator)
      forum_viewable
    end
    
    it "should be able to see a restricted topic" do
      @forum.should_receive(:topics).and_return(@topics)
      @topics.should_receive(:find).and_return(@topic)
      @topic.should_receive(:increment!).with("views")
      @topic.should_receive(:posts).and_return(@posts)
      @topic.should_receive(:readers).and_return(@users)
      @forum.stub!(:title)
      @topic.stub!(:subject)
      get 'show', { :id => @admin_topic.id, :forum_id => @admin_forum.id }
    end
    
    it "should reset the posts count when a user views a topic they are subscribed to" do
      @forum.should_receive(:topics).and_return(@topics)
      @topics.should_receive(:find).and_return(@topic)
      @topic.should_receive(:increment!).with("views")
      @topic.should_receive(:posts).and_return(@posts)
      @topic.should_receive(:readers).and_return(@users)
      @forum.stub!(:title)
      @topic.stub!(:subject)
      get 'show', { :id => @admin_topic.id, :forum_id => @admin_forum.id }
    end
    
    it "should be able to edit any topic" do
      @forum.should_receive(:topics).and_return(@topics)      
      @topics.should_receive(:find).and_return(@topic)
      @topic.should_receive(:posts).and_return(@posts)
      @topic.should_receive(:belongs_to?).and_return(false)
      get 'edit', { :forum_id => 1, :id => 1 }
      response.should_not redirect_to(forum_topic_path)
    end
    
    it "should be able to update any topic" do
      @forum.should_receive(:topics).and_return(@topics)
      @topics.should_receive(:find).and_return(@topic)
      @topic.should_receive(:update_attributes).and_return(true)
      @topic.should_receive(:posts).and_return(@posts)
      @posts.should_receive(:first).and_return(@post)
      @post.should_receive(:update_attributes).and_return(true)
      @topic.should_receive(:belongs_to?).and_return(false)
      put 'update', { :forum_id => 1, :id => 1, :topic => { :subject => "Test" }, :post => { :text => "One." } }
      response.should redirect_to(forum_topic_path(@forum,@topic))
      flash[:notice].should eql(t(:topic_updated))
    end
    
    it "should not be able to update a topic with invalid attributes for a topic" do
      @forum.should_receive(:topics).and_return(@topics)
      @topics.should_receive(:find).and_return(@topic)
      @topic.should_receive(:belongs_to?).and_return(false)
      @topic.should_receive(:update_attributes).and_return(false)
      put 'update', { :forum_id => 1, :id => 1, :topic => { :subject => "" }, :post => { :text => "One." } }
      response.should render_template("edit")
      flash[:notice].should eql(t(:topic_not_updated))
    end
    
    it "should not be able to update a topic with invalid attributes for a topic" do
      @forum.should_receive(:topics).and_return(@topics)
      @topics.should_receive(:find).and_return(@topic)
      @topic.should_receive(:belongs_to?).and_return(false)
      @topic.should_receive(:update_attributes).and_return(true)
      @topic.should_receive(:posts).and_return(@posts)
      @posts.should_receive(:first).and_return(@post)
      @post.should_receive(:update_attributes).and_return(false)
      put 'update', { :forum_id => 1, :id => 1, :topic => { :subject => "Test" }, :post => { :text => "" } }
      response.should render_template("edit")
      flash[:notice].should eql(t(:post_not_updated))
    end
    
    it "should be able to begin to create a new topic" do
      @forum.should_receive(:topics).and_return(@topics)
      @topics.should_receive(:new).and_return(@topic)
      @topic.should_receive(:posts).and_return(@posts)
      @posts.should_receive(:build).and_return(@post)
      get 'new', { :forum_id => forums(:admins_only).id }
    end
    
    it "should not be able to create a new topic with a blank subject" do
      post 'create', { :topic => { :subject => ""}, :post => { :text => "New text!"}, :forum_id => forums(:admins_only).id }
      flash[:notice].should eql("Topic was not created.")
      response.should render_template("new")
    end
    
    it "should be able to create a topic" do
      post 'create', { :topic => { :subject => "Subject"}, :post => { :text => "New text!"}, :forum_id => forums(:admins_only).id }
      flash[:notice].should eql("Topic has been created.")
      
    end
    
  end
  
end