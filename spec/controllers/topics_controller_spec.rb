require File.dirname(__FILE__) + '/../spec_helper'
describe TopicsController do
  fixtures :users, :forums, :topics, :user_levels, :posts

  before do
    @topic = mock("topic")
    @topics = [@topic]
    @post = mock("post")
    @posts = [@post]
    @forum = mock("forum")
    @forums = [@forum]
    @admin_forum = forums(:admins_only)
    @everybody = forums(:everybody)
    @admin_topic = topics(:admin)
    @post = @admin_topic.posts.first
  end
  
  describe TopicsController, "for not logged in user" do
    it "should check to see if a user is logged in before creating a new topic" do
      get 'new', { :forum_id => forums(:admins_only).id }
      response.should redirect_to('login')
      flash[:notice].should eql("You must be logged in to do that.")
    end
    
    it "should not show a restricted topic" do
      Forum.should_receive(:find).and_return(@forum)
      @forum.should_receive(:viewable?).with(false, :false).and_return(false)
      get 'show', { :id => @admin_topic, :forum_id => @admin_forum.id }
      response.should redirect_to(forums_path)
      flash[:notice].should eql("You are not allowed to see topics in this forum.")
    end
  end  

  describe TopicsController, "for logged in plebian" do
    before do
      login_as(:plebian)
    end
  
    it "should stop a user from being able to create a topic in a restricted forum" do
      Forum.should_receive(:find).twice.and_return(@forum)
      @forum.should_receive(:topics_creatable_by?).and_return(false)
      get 'new', { :forum_id => @admin_forum.id }
      response.should redirect_to(forums_path)
      flash[:notice].should eql("You are not allowed to create topics in this forum.")
    end
    
    it "should not create a topic if a user is not allowed" do
      Forum.should_receive(:find).twice.and_return(@forum)
      @forum.should_receive(:topics_creatable_by?).and_return(false)
      post 'create', { :topic => { :subject => "Test!" }, :post => { :text => "Testing!" }, :forum_id => @admin_forum.id }
      response.should redirect_to(forums_path)
      flash[:notice].should eql("You are not allowed to create topics in this forum.")
    end
    
    it "should not be able to see a restricted topic" do
      Forum.should_receive(:find).and_return(@forum)
      @forum.should_receive(:viewable?).and_return(false)
      get 'show', { :id => @admin_topic.id, :forum_id => @admin_forum.id }
      response.should redirect_to(forums_path)
      flash[:notice].should eql("You are not allowed to see topics in this forum.")
    end
    
    it "should be able to reply to a topic" do
      Topic.should_receive(:find).and_return(@topic)
      @topic.should_receive(:last_10_posts).and_return(@posts)
      @topic.should_receive(:posts).and_return(@posts)
      @posts.should_receive(:build).and_return(@post)
      get 'reply', { :forum_id => @everybody.id, :id => @admin_topic.id }
    end
    
    it "should be able to reply to a topic with a quote" do
      Topic.should_receive(:find).and_return(@topic)
      @topic.should_receive(:last_10_posts).and_return(@posts)
      Post.should_receive(:find).and_return(@post)
      @topic.should_receive(:posts).and_return(@posts)
      @posts.should_receive(:build).and_return(@post)
      get 'reply', { :forum_id => @everybody.id, :id => @admin_topic.id, :quote => @post.id }
    end
    
    it "should not be able to moderate topics" do
      post 'moderate', { :commit => "Lock", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
      flash[:notice].should eql("You are not allowed to see topics in this forum.")
    end
  end
  
  describe TopicsController, "for logged in administrator" do
    before do
      login_as(:administrator)
    end
    
    it "should be able to see a restricted topic" do
      Forum.should_receive(:find).and_return(@forum)
      @forum.should_receive(:viewable?).and_return(true) 
      get 'show', { :id => @admin_topic.id, :forum_id => @admin_forum.id }
    end
    
    it "should be able to begin to create a new topic" do
      Topic.should_receive(:new).and_return(@topic)
      get 'new', { :forum_id => forums(:admins_only).id }
    end
    
    it "should not be able to create a new topic with a blank subject" do
      Topic.should_receive(:new).and_return(@topic)
      @topic.stub!(:[]=)
      @topic.should_receive(:posts).and_return(@posts)
      @posts.should_receive(:build).and_return(@post)
      @topic.should_receive(:save).and_return(false)
      post 'create', { :topic => { :subject => ""}, :post => { :text => "New text!"}, :forum_id => forums(:admins_only).id }
      flash[:notice].should eql("Topic was not created.")
      response.should render_template("new")
    end
    
    it "should be able to create a topic" do
      Topic.should_receive(:new).and_return(@topic)
      @topic.stub!(:[]=)
      @topic.should_receive(:posts).and_return(@posts)
      @posts.should_receive(:build).and_return(@post)
      @topic.should_receive(:forum).and_return(@forum)
      @topic.should_receive(:save).and_return(true)
      post 'create', { :topic => { :subject => "Subject"}, :post => { :text => "New text!"}, :forum_id => forums(:admins_only).id }
      flash[:notice].should eql("Topic has been created.")
      #TODO: Test for redirect
    end
    
    it "should be able to lock any topic in the admin forum" do
      Topic.should_receive(:find).and_return(@topic)
      @topic.should_receive(:update_attribute).with("locked", true).and_return(@topic)
      put 'lock', { :id => @admin_topic.id, :forum_id => @admin_forum.id }
      response.should redirect_to(topic_path(@topic))
    end
    
    it "should be able to unlock any topic in the admin forum" do
      Topic.should_receive(:find).and_return(@topic)
      @topic.should_receive(:update_attribute).with("locked", false).and_return(@topic)
      put 'unlock', { :id => @admin_topic.id, :forum_id => @admin_forum.id }
      response.should redirect_to(topic_path(@topic))
    end
    
    
    it "should be able to lock multiple topics" do
      Topic.should_receive(:find).twice.and_return(@topic)
      @topic.should_receive(:update_attribute).twice.with("locked", true)
      post 'moderate', { :commit => "Lock", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
      flash[:notice].should eql("All selected topics have been locked.")
    end
    
    it "should be able to unlock multiple topics" do
      Topic.should_receive(:find).twice.and_return(@topic)
      @topic.should_receive(:update_attribute).twice.with("locked", false)
      post 'moderate', { :commit => "Unlock", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
      flash[:notice].should eql("All selected topics have been unlocked.")
    end
    
    it "should be able to destroy multiple topics" do
      Topic.should_receive(:find).twice.and_return(@topic)
      @topic.should_receive(:destroy).twice.and_return(@topic)
      post 'moderate', { :commit => "Delete", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
      flash[:notice].should eql("All selected topics have been deleted.")
    end
    
    it "should be able to sticky multiple topics" do
      Topic.should_receive(:find).twice.and_return(@topic)
      @topic.should_receive(:update_attribute).twice.with("sticky", true)
      post 'moderate', { :commit => "Sticky", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
      flash[:notice].should eql("All selected topics have been stickied.")
    end
    
    it "should be able to sticky multiple topics" do
      Topic.should_receive(:find).twice.and_return(@topic)
      @topic.should_receive(:update_attribute).twice.with("sticky", false)
      post 'moderate', { :commit => "Unsticky", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
      flash[:notice].should eql("All selected topics have been unstickied.")
    end
    
  end
  
  describe TopicsController, "for logged in moderator" do
    before do
      login_as(:moderator)
    end
    
    it "should not be able to lock any topic in the admin forum" do
      put 'lock', { :id => @admin_topic.id, :forum_id => @admin_forum.id }
      response.should redirect_to(forums_path)
      flash[:notice].should eql("You are not allowed to see topics in this forum.")
    end
  end
end