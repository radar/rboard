require File.dirname(__FILE__) + '/../spec_helper'
describe Moderator::ModerationsController do
  fixtures :users, :moderations, :topics, :posts, :forums
  
  before do
    @moderation = mock_model(Moderation)
    @moderations = [@moderation]
    @topic = mock_model(Topic)
    @forum = mock_model(Forum)
  end
  
  describe Moderator::ModerationsController, "a user" do
    before do
      login_as(:plebian)
    end
    
    it "should not be able to see the index page" do
      get 'index'
      response.should redirect_to(root_path)
      flash[:notice].should_not be_nil
    end
  end
  
  describe Moderator::ModerationsController, "a moderator" do
    before do
      login_as(:moderator)
    end
    
    it "should be able to see the index page" do
      Moderation.should_receive(:topics).and_return(@moderations)
      Moderation.should_receive(:posts).and_return(@moderations)
      @moderations.should_receive(:for_user).twice.and_return(@moderations)
      Forum.should_receive(:viewable_to).and_return(@forums)
      get 'index'
    end
    
    it "should be able to create a moderation" do
      Topic.should_receive(:find).and_return(@topic)
      @topic.should_receive(:moderations).and_return(@moderations)
      @moderations.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:first).and_return(nil)
      @moderations.should_receive(:create).and_return(@moderation)
      @topic.should_receive(:forum).and_return(@forum)
      @forum.should_receive(:moderations).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:count).and_return(1)
      post 'create', :topic_id => 1
    end
    
    it "should try to create a moderation, but finding it there should destroy it" do
      Topic.should_receive(:find).and_return(@topic)
      @topic.should_receive(:moderations).and_return(@moderations)
      @moderations.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:first).and_return(@moderation)
      @moderation.should_receive(:destroy).and_return(@moderation)
      @moderation.should_receive(:moderated_object).and_return(@topic)
      @topic.should_receive(:forum).and_return(@forum)
      @forum.should_receive(:moderations).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:count).and_return(0)
      post 'create', :topic_id => 1
    end
    
    it "should be able to begin to edit a moderation" do
      Moderation.should_receive(:find).and_return(@moderation)
      get 'edit', :id => 1
    end
    
    it "should not be able to edit a moderation that does not exist" do
      Moderation.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      get 'edit', :id => 123456789
      response.should redirect_to(moderator_moderations_path)
      flash[:notice].should_not be_nil
    end
    
    it "should be able to update a moderation" do
      Moderation.should_receive(:find).and_return(@moderation)
      @moderation.should_receive(:update_attributes).and_return(true)
      put 'update', :moderation => { :reason => "Because." }
      flash[:notice].should_not be_nil
      response.should redirect_to(moderator_moderations_path)
    end
    
    it "should not be able to update a moderation without a valid reason" do
      Moderation.should_receive(:find).and_return(@moderation)
      @moderation.should_receive(:update_attributes).and_return(false)
      put 'update', :moderation => { :reason => "" }
      flash[:notice].should_not be_nil
      response.should render_template("edit")
    end
      
  end
end