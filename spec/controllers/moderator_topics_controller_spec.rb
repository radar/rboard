require File.dirname(__FILE__) + '/../spec_helper'

describe Moderator::TopicsController do
  
  fixtures :topics, :users, :forums, :moderations, :group_users, :groups, :permissions
  before do
    @admin_topic = topics(:admin)
    @moderator_topic = topics(:moderator)
    @user_topic = topics(:user)
  end
  
  def moderation_ids
    [moderations(:first).id, moderations(:second).id]
  end
  
  def not_allowed
    flash[:notice].should eql(t(:forum_object_permission_denied, :object => "topic"))
  end
  
  describe "A moderator" do 
    before do
      login_as(:moderator)
    end
    
    it "should not be able to toggle the locked status any topic in the admin forum" do
      put 'lock', { :id => @admin_topic.id }
      not_allowed
    end
    
    it "should not be able to toggle the stickied status any topic in the admin forum" do
      put 'sticky', { :id => @admin_topic.id }
      not_allowed
    end
  
    it "should not be able to delete a topic in the admin forum" do
      delete 'destroy', { :id => @admin_topic.id }
      not_allowed
    end
    
    it "should be allowed to delete a topic in the moderator forum" do
      delete 'destroy', { :id => @moderator_topic.id }
      response.should redirect_to(moderator_moderations_path)
    end
    
    it "should be able to lock topics for moderations selected on the moderations page" do
      put 'moderate', { :commit => "Lock", :moderation_ids => moderation_ids }
      flash[:notice].should eql(t(:topics_locked))
      response.should redirect_to(root_path)
    end
  
    it "should be able to unlock topics for moderations selected on the moderations page" do
      put 'moderate', { :commit => "Unlock", :moderation_ids => moderation_ids }
      flash[:notice].should eql(t(:topics_unlocked))
      response.should redirect_to(moderator_moderations_path)
    end
  
    it "should be able to delete topics for moderations selected on the moderations page" do
      put 'moderate', { :commit => "Delete", :moderation_ids => moderation_ids }
      flash[:notice].should eql("All selected topics have been deleted.")
      response.should redirect_to(moderator_moderations_path)
    end
  
    it "should be able to sticky topics for moderations selected on the moderations page" do
      put 'moderate', { :commit => "Sticky", :moderation_ids => moderation_ids }
      flash[:notice].should eql(t(:topics_stickied))
      response.should redirect_to(moderator_moderations_path)
    end
  
    it "should be able to unsticky topics for moderations selected on the moderations page" do
      put 'moderate', { :commit => "Unsticky", :moderation_ids => moderation_ids }
      flash[:notice].should eql(t(:topics_unstickied))
      response.should redirect_to(moderator_moderations_path)
    end
  
    it "should be able to move topics for moderations selected on the moderations page" do
      put 'moderate', { :commit => "Move", :moderation_ids => moderation_ids, :new_forum_id => 1 }
      flash[:notice].should eql(t(:topics_moved))
      response.should redirect_to(forum_path(1))
    end
    
    it "should be able to begin to merge for moderations selected on the moderations page" do
      put 'moderate', { :commit => "Merge", :moderation_ids => moderation_ids }
      response.should render_template("merge")
    end
  
    it "should be able to begin to merge for moderations selected on the moderations page" do
      put 'moderate', { :commit => "Merge", :moderation_ids => moderation_ids, :new_subject => "Puppies", :master_topic_id => 1 }, { :user => users(:moderator).id, :moderation_ids => moderation_ids }
      flash[:notice].should eql(t(:topics_merged))
      response.should redirect_to(forums_path)
    end
  
    it "shouldn't be able to merge a single topic" do
      put 'moderate', { :commit => "Merge", :moderation_ids => [@user_topic.id], :new_subject => "Puppies", :master_topic_id => @user_topic.id }, { :user => users(:moderator).id, :moderation_ids => [@user_topic.id] }
      flash[:notice].should eql(t(:only_one_topic_for_merge))
      response.should redirect_to(forums_path)
    end
  
    it "shouldn't be able to merge topics in forums they do not have access to" do
      put 'moderate', { :commit => "Merge", :moderation_ids => moderation_ids + [@admin_topic.id], :new_subject => "Puppies", :master_topic_id => @user_topic.id }, { :user => users(:moderator).id, :moderation_ids => moderation_ids + [@admin_topic.id] }
      flash[:notice].should eql(t(:topics_not_accessible_by_you))
      response.should redirect_to(forums_path)
    end
  
    it "shouldn't be able to merge topics that don't exist" do
      put 'moderate', { :commit => "Merge", :moderation_ids => moderation_ids + [123456789], :new_subject => "Puppies", :master_topic_id => @user_topic.id }, { :user => users(:moderator).id, :moderation_ids => moderation_ids + [123456789] }
      flash[:notice].should eql(t(:not_found, :thing => "moderation"))
      response.should redirect_to(moderator_moderations_path)
    end
    
    it "should not be able to act on moderations that don't belong to them" do
      put 'moderate', { :commit => "Lock", :moderation_ids => [2,3,4] }
      response.should redirect_to(moderator_moderations_path)
      flash[:notice].should_not be_nil
    end
  
    it "should be able to lock a topic" do
      put 'lock', :id => 1
    end
  
    it "should be able to sitcky a topic" do
      put 'sticky', :id => 1
    end    
  
    it "should not be able to toggle a lock on a topic that does not exist" do
      put 'lock', :id => 123456789
    end
  end
end