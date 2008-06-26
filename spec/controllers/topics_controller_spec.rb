require File.dirname(__FILE__) + '/../spec_helper'
describe TopicsController do
  fixtures :users, :forums, :topics

  before do
    @topic = mock("topic")
    @topics = [@topic]
    @forum = mock("forum")
    @forums = [@forum]
  end
  
  describe TopicsController, "for not logged in user" do
    it "should check to see if a user is logged in before creating a new topic" do
      get 'new', { :forum_id => forums(:admins_only).id }
      response.should redirect_to('login')
      flash[:notice].should eql("You must be logged in to do that.")
    end
    it "should not show a restricted topic" do
      Forum.should_receive(:find).and_return(@forum)
      @forum.should_receive(:is_visible_to).and_return(users(:plebian).id)
      get 'show', { :id => topics(:admin).id }
      response.should redirect_to(forums_path)
      flash[:notice].should eql("You do not have the permissions to access that topic.")
    end
  end  

  describe TopicsController, "for logged in plebian" do
    before do
      login_as(:plebian)
    end
  
    it "should stop a user from being able to create a topic in a restricted forum" do
      Forum.should_receive(:find).at_least(3).times.and_return(@forum)
      @forum.should_receive(:topics_created_by).and_return(forums(:admins_only).id)
      get 'new', { :forum_id => forums(:admins_only).id }
      response.should redirect_to(forums_path)
      flash[:notice].should eql("You do not have permissions to create topics in this forum.")
    end
    
    it "should not create a topic if a user is not allowed" do
      Forum.should_receive(:find).at_least(3).times.and_return(@forum)
      @forum.should_receive(:topics_created_by).and_return(forums(:admins_only).id)
      @forum.should_not_receive(:last_post=)
      @forum.should_not_receive(:last_post_forum=)
      @forum.should_not_receive(:save)
      @forum.should_not_receive(:sub?)
      post 'create', { :topic => { :subject => "Test!" }, :post => { :text => "Testing!" }, :forum_id => forums(:admins_only).id }
      response.should redirect_to(forums_path)
      flash[:notice].should eql("You do not have permissions to create topics in this forum.")
    end
  end
  
  describe TopicsController, "for logged in administrator" do
    before do
      login_as(:administrator)
    end
    
    it "should be able to see a restricted topic" do
      Topic.should_receive(:find).twice.and_return(@topic)
      @topic.should_receive(:forum).and_return(@forum)
      @forum.should_receive(:is_visible_to).twice.and_return(forums(:admins_only).is_visible_to)    
      get 'show', { :id => topics(:admin), :forum_id => forums(:admins_only).id }
    end
    
    it "should be able to begin to create a new topic" do
      Topic.should_receive(:new).and_return(@topic)
      get 'new', { :forum_id => forums(:admins_only).id }
    end
    
    it "should be able to create a new topic" do
      post 'create', { :topic => { :subject => "New topic!"}, :post => { :text => "New text!"}, :forum_id => forums(:admins_only).id }
      response.should redirect_to(forum_topic_path(forums(:admins_only), @topic))
      flash[:notice].should eql("Topic has been created.")
    end
  end
end
  

