require File.dirname(__FILE__) + '/../spec_helper'

describe Moderator::TopicsController do
  
  fixtures :topics, :users, :forums, :moderations
  before do
    login_as(:moderator)
    @admin_topic = topics(:admin)
    @moderator_topic = topics(:moderator)
    @topic = mock_model(Topic)
    @single_topic = [@topic]
    @topics = [@topic, @topic]
    @forum = mock_model(Forum)
    @moderation = mock_model(Moderation)
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
      flash[:notice].should eql(I18n.t(:not_allowed_to_access_topic))
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
    
    it "should be allowed to delete a topic in the moderator forum" do
      Topic.should_receive(:find).and_return(@topic)
      @topic.should_receive(:forum).and_return(@forum)
      @forum.should_receive(:viewable?).and_return(true)
      @topic.should_receive(:destroy).and_return(@topic)
      delete 'destroy', { :id => @moderator_topic.id }
      flash[:notice].should_not be_nil
      response.should redirect_to(moderator_moderations_path)
    end
    
    it "should be able to lock topics for moderations selected on the moderations page" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:lock!).and_return(@moderation)
      put 'moderate', { :commit => "Lock", :moderation_ids => [1,2,3] }
      flash[:notice].should eql(I18n.t(:topics_locked))
      response.should redirect_to(moderator_moderations_path)
    end
    
    it "should be able to unlock topics for moderations selected on the moderations page" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:unlock!).and_return(@moderation)
      put 'moderate', { :commit => "Unlock", :moderation_ids => [1,2,3] }
      flash[:notice].should eql(I18n.t(:topics_unlocked))
      response.should redirect_to(moderator_moderations_path)
    end
    
    it "should be able to delete topics for moderations selected on the moderations page" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:destroy!).and_return(@moderation)
      put 'moderate', { :commit => "Delete", :moderation_ids => [1,2,3] }
      flash[:notice].should eql("All selected topics have been deleted.")
      response.should redirect_to(moderator_moderations_path)
    end
    
    it "should be able to sticky topics for moderations selected on the moderations page" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:sticky!).and_return(@moderation)
      put 'moderate', { :commit => "Sticky", :moderation_ids => [1,2,3] }
      flash[:notice].should eql(I18n.t(:topics_stickied))
      response.should redirect_to(moderator_moderations_path)
    end
    
    it "should be able to unsticky topics for moderations selected on the moderations page" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:unsticky!).and_return(@moderation)
      put 'moderate', { :commit => "Unsticky", :moderation_ids => [1,2,3] }
      flash[:notice].should eql(I18n.t(:topics_unstickied))
      response.should redirect_to(moderator_moderations_path)
    end
    
    it "should be able to move topics for moderations selected on the moderations page" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:move!).and_return(@moderation)
      put 'moderate', { :commit => "Move", :moderation_ids => [1,2,3], :new_forum_id => 1 }
      flash[:notice].should eql(I18n.t(:topics_moved))
      response.should redirect_to(forum_path(1))
    end
      
    it "should be able to begin to merge for moderations selected on the moderations page" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:moderated_object_id).and_return(1)
      Topic.should_receive(:find).and_return(@topics)
      put 'moderate', { :commit => "Merge", :moderation_ids => [1,2,3] }
    end
    
    it "should be able to begin to merge for moderations selected on the moderations page" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:moderated_object_id).and_return(1)
      Topic.should_receive(:find).and_return(@topics, @topic)
      @topic.should_receive(:forum).twice.and_return(@forum)
      @topic.should_receive(:merge!).and_return(true)
      @forum.should_receive(:viewable?).twice.and_return(true)
      put 'moderate', { :commit => "Merge", :moderation_ids => [1,2,3], :new_subject => "Puppies", :master_topic_id => 1 }, { :user => users(:moderator).id, :moderation_ids => [1,2,3] }
      flash[:notice].should eql(I18n.t(:topics_merged))
      response.should redirect_to(forums_path)
    end
    
    it "shouldn't be able to merge a single topic" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:moderated_object_id).and_return(1)
      Topic.should_receive(:find).and_return(@single_topic)
      put 'moderate', { :commit => "Merge", :moderation_ids => [1], :new_subject => "Puppies", :master_topic_id => 1 }, { :user => users(:moderator).id, :moderation_ids => [1] }
      flash[:notice].should eql(I18n.t(:only_one_topic_for_merge))
      response.should redirect_to(forums_path)
    end
    
    it "shouldn't be able to merge topics in forums they do not have access to" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:moderated_object_id).and_return(1)
      Topic.should_receive(:find).and_return(@topics)
      @topic.should_receive(:forum).and_return(@forum)
      @forum.should_receive(:viewable?).and_return(false)
      put 'moderate', { :commit => "Merge", :moderation_ids => [1,2,3], :new_subject => "Puppies", :master_topic_id => 1 }, { :user => users(:moderator).id, :moderation_ids => [1,2,3] }
      flash[:notice].should eql(I18n.t(:topics_not_accessible_by_you))
      response.should redirect_to(forums_path)
    end
    
    it "shouldn't be able to merge topics that don't exist" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:moderated_object_id).and_return(1)
      Topic.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      put 'moderate', { :commit => "Merge", :moderation_ids => [1,2,3], :new_subject => "Puppies", :master_topic_id => 1 }, { :user => users(:moderator).id, :moderation_ids => [1,2,3] }
      flash[:notice].should eql(I18n.t(:topic_not_found))
      response.should redirect_to(moderator_moderations_path)
    end
      
    it "should not be able to act on moderations that don't belong to them" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      put 'moderate', { :commit => "Lock", :moderation_ids => [2,3,4] }
      response.should redirect_to(moderator_moderations_path)
      flash[:notice].should_not be_nil
    end
    
    it "should be able to toggle a lock on a topic" do
      Topic.should_receive(:find).and_return(@topic)
      @topic.should_receive(:locked?).and_return(true)
      @topic.should_receive(:forum).and_return(@forum)
      @forum.should_receive(:viewable?).and_return(true)
      @topic.should_receive(:toggle!).and_return(true)
      @topic.should_receive(:moderations).and_return(@moderations)
      @moderations.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:delete_all).and_return(0)
      put 'toggle_lock', :id => 1
    end
    
    it "should be able to toggle a sitcky on a topic" do
      Topic.should_receive(:find).and_return(@topic)
      @topic.should_receive(:sticky?).and_return(true)
      @topic.should_receive(:forum).and_return(@forum)
      @forum.should_receive(:viewable?).and_return(true)
      @topic.should_receive(:toggle!).and_return(true)
      @topic.should_receive(:moderations).and_return(@moderations)
      @moderations.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:delete_all).and_return(0)
      put 'toggle_sticky', :id => 1
    end    
    
    it "should not be able to toggle a lock on a topic that does not exist" do
      Topic.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      put 'toggle_lock', :id => 123456789
    end
    
  end
end