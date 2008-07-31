require File.dirname(__FILE__) + '/../spec_helper'
describe TopicsController do
  fixtures :users, :forums, :topics, :user_levels

  before do
    @topic = mock("topic")
    @topics = [@topic]
    @forum = mock("forum")
    @forums = [@forum]
    @admin_forum = forums(:admins_only)
    @admin_topic = topics(:admin)
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
      flash[:notice].should eql("You do not have the permissions to access that topic.")
    end
  end  

  describe TopicsController, "for logged in plebian" do
    before do
      login_as(:plebian)
    end
  
    it "should stop a user from being able to create a topic in a restricted forum" do
      Forum.should_receive(:find).twice.and_return(@forum)
      @forum.should_receive(:topics_created_by).and_return(user_levels(:administrator))
      get 'new', { :forum_id => @admin_forum.id }
      response.should redirect_to(forums_path)
      flash[:notice].should eql("You do not have permissions to create topics in this forum.")
    end
    
    it "should not create a topic if a user is not allowed" do
      Forum.should_receive(:find).twice.and_return(@forum)
      @forum.should_receive(:topics_created_by).and_return(user_levels(:administrator))
      @forum.should_not_receive(:last_post=)
      @forum.should_not_receive(:last_post_forum=)
      @forum.should_not_receive(:save)
      @forum.should_not_receive(:sub?)
      post 'create', { :topic => { :subject => "Test!" }, :post => { :text => "Testing!" }, :forum_id => @admin_forum.id }
      response.should redirect_to(forums_path)
      flash[:notice].should eql("You do not have permissions to create topics in this forum.")
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
    
    it "should be able to create a new topic" do
      post 'create', { :topic => { :subject => "New topic!"}, :post => { :text => "New text!"}, :forum_id => forums(:admins_only).id }
      flash[:notice].should eql("Topic has been created.")
    end
  end
end
  

