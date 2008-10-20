require File.dirname(__FILE__) + '/../spec_helper'
describe Moderator::TopicsController, "as moderator" do
  
  fixtures :topics, :users, :forums, :moderations
  before do
    login_as(:moderator)
    @admin_topic = topics(:admin)
    @topic = mock(:topic)
    @forum = mock(:forum)
    @moderation = mock(:moderation)
    @moderations = [@moderation]
  end
  
  it "should not be able to lock any topic in the admin forum" do
    Topic.should_receive(:find).and_return(@topic)
    @topic.should_receive(:forum).and_return(@forum)
    @forum.should_receive(:viewable?).and_return(false)
    @topic.should_receive(:moderations).and_return(@moderations)
    @moderations.should_receive(:for_user).and_return(@moderations)
    @moderation.should_receive(:destroy).and_return(@moderation)
    
    @topic.should_not_receive(:toggle!)
    put 'toggle_lock', { :id => @admin_topic.id }
    response.should redirect_to(moderator_moderations_path)
  end
    
    # it "should be able to unlock any topic in the admin forum" do
    #      Forum.should_receive(:find).and_return(@forum)
    #      @forum.should_receive(:viewable?).and_return(true)
    #      @topic.should_receive(:unlock!).and_return(@topic)
    #      @topic.should_receive(:forum).and_return(@forum)
    #      @forum.should_receive(:topics).and_return(@topics)
    #      @topics.should_receive(:find).with(@admin_topic.id.to_s, :joins => :posts).and_return(@topic)
    #      @topic.stub!(:has_key?).and_return(true)
    #      put 'unlock', { :id => @admin_topic.id, :forum_id => @admin_forum.id }
    #    end
    #    
    #  TODO: Move these to moderations controller spec testing.    
    #    it "should be able to lock multiple topics" do
    #      Forum.should_receive(:find).and_return(@forum)
    #      @forum.should_receive(:viewable?).and_return(true)
    #      Topic.should_receive(:find).twice.and_return(@topic)
    #      @topic.should_receive(:lock!).twice
    #      post 'moderate', { :commit => "Lock", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
    #      flash[:notice].should eql("All selected topics have been locked.")
    #    end
    #    
    #    it "should be able to unlock multiple topics" do
    #      Forum.should_receive(:find).and_return(@forum)
    #      @forum.should_receive(:viewable?).and_return(true)
    #      Topic.should_receive(:find).twice.and_return(@topic)
    #      @topic.should_receive(:unlock!).twice
    #      post 'moderate', { :commit => "Unlock", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
    #      flash[:notice].should eql("All selected topics have been unlocked.")
    #    end
    #    
    #    it "should be able to destroy multiple topics" do
    #      Forum.should_receive(:find).and_return(@forum)
    #      @forum.should_receive(:viewable?).and_return(true)
    #      Topic.should_receive(:find).twice.and_return(@topic)
    #      @topic.should_receive(:destroy).twice.and_return(@topic)
    #      post 'moderate', { :commit => "Delete", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
    #      flash[:notice].should eql("All selected topics have been deleted.")
    #    end
    #    
    #    it "should be able to sticky multiple topics" do
    #      Forum.should_receive(:find).and_return(@forum)
    #      @forum.should_receive(:viewable?).and_return(true)
    #      Topic.should_receive(:find).twice.and_return(@topic)
    #      @topic.should_receive(:sticky!).twice
    #      post 'moderate', { :commit => "Sticky", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
    #      flash[:notice].should eql("All selected topics have been stickied.")
    #    end
    #    
    #    it "should be able to unsticky multiple topics" do
    #      Forum.should_receive(:find).and_return(@forum)
    #      @forum.should_receive(:viewable?).and_return(true)
    #      Topic.should_receive(:find).twice.and_return(@topic)
    #      @topic.should_receive(:unsticky!).twice
    #      post 'moderate', { :commit => "Unsticky", :moderated_topics => [1,2], :forum_id => @admin_forum.id } 
    #      flash[:notice].should eql("All selected topics have been unstickied.")
    #    end
  end