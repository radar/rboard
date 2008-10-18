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
      @forum.should_receive(:topics).and_return(@topics)
      @topics.should_receive(:find).and_return(@topic)
      @topic.should_receive(:increment!).with("views")
      @topic.should_receive(:posts).and_return(@posts)
      @forum.stub!(:title)
      @topic.stub!(:subject)
      get 'show', { :id => @admin_topic.id, :forum_id => @admin_forum.id }
    end
    
    it "should be able to begin to create a new topic" do
      Topic.should_receive(:new).and_return(@topic)
      @topic.should_receive(:posts).and_return(@posts)
      @posts.should_receive(:build).and_return(@post)
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
      @topic.should_receive(:update_attribute).with("last_post_id", @post.id).and_return(true)
      post 'create', { :topic => { :subject => "Subject"}, :post => { :text => "New text!"}, :forum_id => forums(:admins_only).id }
      flash[:notice].should eql("Topic has been created.")
      #TODO: Test for redirect
    end
    
    it "should be able to lock any topic in the admin forum" do
      Forum.should_receive(:find).and_return(@forum)
      @forum.should_receive(:viewable?).and_return(true)
      Topic.should_receive(:find).and_return(@topic)
      @topic.should_receive(:lock!).and_return(@topic)
      @topic.should_receive(:forum).and_return(@forum)
      put 'lock', { :id => @admin_topic.id, :forum_id => @admin_forum.id }
      response.should redirect_to(forum_topic_path(@forum, @topic))
    end
    
    it "should be able to unlock any topic in the admin forum" do
      Forum.should_receive(:find).and_return(@forum)
      @forum.should_receive(:viewable?).and_return(true)
      Topic.should_receive(:find).and_return(@topic)
      @topic.should_receive(:unlock!).and_return(@topic)
      @topic.should_receive(:forum).and_return(@forum)
      @topic.stub!(:has_key?).and_return(true)
      put 'unlock', { :id => @admin_topic.id, :forum_id => @admin_forum.id }
    end
    
  # TODO: Move these to moderations controller spec testing.    
  #   it "should be able to lock multiple topics" do
  #     Forum.should_receive(:find).and_return(@forum)
  #     @forum.should_receive(:viewable?).and_return(true)
  #     Topic.should_receive(:find).twice.and_return(@topic)
  #     @topic.should_receive(:lock!).twice
  #     post 'moderate', { :commit => "Lock", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
  #     flash[:notice].should eql("All selected topics have been locked.")
  #   end
  #   
  #   it "should be able to unlock multiple topics" do
  #     Forum.should_receive(:find).and_return(@forum)
  #     @forum.should_receive(:viewable?).and_return(true)
  #     Topic.should_receive(:find).twice.and_return(@topic)
  #     @topic.should_receive(:unlock!).twice
  #     post 'moderate', { :commit => "Unlock", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
  #     flash[:notice].should eql("All selected topics have been unlocked.")
  #   end
  #   
  #   it "should be able to destroy multiple topics" do
  #     Forum.should_receive(:find).and_return(@forum)
  #     @forum.should_receive(:viewable?).and_return(true)
  #     Topic.should_receive(:find).twice.and_return(@topic)
  #     @topic.should_receive(:destroy).twice.and_return(@topic)
  #     post 'moderate', { :commit => "Delete", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
  #     flash[:notice].should eql("All selected topics have been deleted.")
  #   end
  #   
  #   it "should be able to sticky multiple topics" do
  #     Forum.should_receive(:find).and_return(@forum)
  #     @forum.should_receive(:viewable?).and_return(true)
  #     Topic.should_receive(:find).twice.and_return(@topic)
  #     @topic.should_receive(:sticky!).twice
  #     post 'moderate', { :commit => "Sticky", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
  #     flash[:notice].should eql("All selected topics have been stickied.")
  #   end
  #   
  #   it "should be able to unsticky multiple topics" do
  #     Forum.should_receive(:find).and_return(@forum)
  #     @forum.should_receive(:viewable?).and_return(true)
  #     Topic.should_receive(:find).twice.and_return(@topic)
  #     @topic.should_receive(:unsticky!).twice
  #     post 'moderate', { :commit => "Unsticky", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
  #     flash[:notice].should eql("All selected topics have been unstickied.")
  #   end
    
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