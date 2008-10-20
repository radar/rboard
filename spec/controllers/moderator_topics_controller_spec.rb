require File.dirname(__FILE__) + '/../spec_helper'

describe Moderator::TopicsController do
  
  fixtures :topics, :users, :forums, :moderations
  before do
    login_as(:moderator)
    @admin_topic = topics(:admin)
    @topic = mock(:topic)
    @forum = mock(:forum)
    @moderation = mock(:moderation)
    @moderations = [@moderation]
  end
  
  
  describe Moderator::TopicsController, "as moderator" do
    
    def find_topic_mock
      Topic.should_receive(:find).and_return(@topic)
      @topic.should_receive(:forum).and_return(@forum)
      @forum.should_receive(:viewable?).and_return(false)
      @topic.should_receive(:moderations).and_return(@moderations)
      @moderations.should_receive(:for_user).and_return(@moderations)
      @moderation.should_receive(:destroy).and_return(@moderation)
    end
    
    def not_allowed
      flash[:notice].should eql("You are not allowed to access that topic.")
      response.should redirect_to(moderator_moderations_path)
    end
    
  
    it "should not be able to toggle the locked status any topic in the admin forum" do
      find_topic_mock
      @topic.should_not_receive(:toggle!)
      put 'toggle_lock', { :id => @admin_topic.id }
      not_allowed
    end
  
    it "should not be able to toggle the stickied status any topic in the admin forum" do
      find_topic_mock
      @topic.should_not_receive(:toggle!)
      put 'toggle_sticky', { :id => @admin_topic.id }
      not_allowed
    end
    
    it "should not be able to delete a topic in the admin forum" do
      find_topic_mock
      @topic.should_not_receive(:destroy)
      delete 'destroy', { :id => @admin_topic.id }
      not_allowed
    end
    
  end
end