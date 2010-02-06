require File.dirname(__FILE__) + '/../../spec_helper'

describe Moderator::TopicsController do

  before do
    setup_user_base
    setup_forums
    @admin_topic = Forum("Admins Only").topics.first
    @moderator_topic = Forum("Moderators Only").topics.first
    @user_topic = Forum("Public Forum").topics.first
    @moderation = @moderator_topic.moderations.create(:user => User("moderator"))
    @other_moderation = @user_topic.moderations.create(:user => User("moderator"))
    @moderator = User("moderator")
    login_as(:moderator)
  end

  it "should be able to destroy a topic" do
    delete 'destroy', :id => @moderator_topic.id
    flash[:notice].should eql(t(:deleted, :thing => "topic"))
    response.should redirect_to(moderator_moderations_path)
  end

  it "should be able to lock a set of topics" do
    post 'moderate', { :moderation_ids => [@moderation.id], :commit => "Lock" }
    flash[:notice].should eql(t(:topics_locked))
  end

  it "should be able to unlock a set of topics" do
    post 'moderate', { :moderation_ids => [@moderation.id], :commit => "Unlock" }
    flash[:notice].should eql(t(:topics_unlocked))
  end

  it "should be able to delete a set of topics" do
    post 'moderate', { :moderation_ids => [@moderation.id], :commit => "Delete" }
    flash[:notice].should eql(t(:topics_deleted))
  end

  it "should be able to sticky a set of topics" do
    post 'moderate', { :moderation_ids => [@moderation.id], :commit => "Sticky" }
    flash[:notice].should eql(t(:topics_stickied))
  end

  it "should be able to unsticky a set of topics" do
    post 'moderate', { :moderation_ids => [@moderation.id], :commit => "Unsticky" }
    flash[:notice].should eql(t(:topics_unstickied))
  end

  it "should be able to move a set of topics" do
    post 'moderate', { :moderation_ids => [@moderation.id], :new_forum_id => Forum("Public Forum"), :commit => "Move" }
    flash[:notice].should eql(t(:topics_moved))
  end

  it "should be able to begin to merge two topics" do
    post 'moderate', { :moderation_ids => [@moderation.id, @other_moderation.id], :commit => "Merge" }
    response.should render_template("merge")
  end

  it "shouldn't do anything with moderations that don't exist" do
    post 'moderate', { :moderation_ids => [4,12,87], :commit => "Lock" }
    flash[:notice].should eql(t(:not_found, :thing => "moderation"))
    response.should redirect_to(moderator_moderations_path)
  end

  it "shouldn't be able to merge a single topic" do
    post 'moderate', { :moderation_ids => [@moderation.id], :commit => "Merge" }
    flash[:notice].should eql(t(:only_one_topic_for_merge))
    response.should redirect_to(forums_path)
  end

  it "should be able to merge two topics" do
    put 'merge', { :master_topic_id => @moderator_topic.id, :new_subject => "New Subject" }, { :user => @moderator, :moderation_ids => [@moderator_topic.id, @user_topic.id] }
    flash[:notice].should eql(t(:topics_merged))
    response.should redirect_to(forums_path)
  end

  it "should not be able to merge a topic from the admin forum" do
    put 'merge', { :master_topic_id => @moderator_topic.id, :new_subject => "New Subject" }, { :user => @moderator, :moderation_ids => [@moderator_topic.id, @admin_topic.id] }
    flash[:notice].should eql(t(:topics_not_accessible_by_you))
    response.should redirect_to(forums_path)
  end

  it "should not be able to merge topics that do not exist" do
    put 'merge', { :master_topic_id => @moderator_topic.id, :new_subject => "New Subject" }, { :user => @moderator, :moderation_ids => [4,12,87] }
    flash[:notice].should eql(t(:not_found, :thing => "topics"))
    response.should redirect_to(moderator_moderations_path)
  end

  it "should be able to lock a single topic" do
    put 'lock', :id => @moderator_topic.id
    flash[:notice].should eql(t(:topic_locked_or_unlocked, :status => "locked"))
    response.should redirect_to(moderator_moderations_path)
  end

  it "should be able to sticky a single topic" do
    put 'sticky', :id => @moderator_topic.id
    flash[:notice].should eql(t(:topic_sticky_or_unsticky, :status => "stickied"))
    response.should redirect_to(moderator_moderations_path)
  end

  it "should not be able to lock a topic in the admin forum" do
    put 'lock', :id => @admin_topic.id
    flash[:notice].should eql(t(:forum_object_permission_denied, :object => "topic"))
    response.should redirect_to(moderator_moderations_path)
  end

  it "should not be able to lock a topic that does not exist" do
    put 'lock', :id => 1234567890
    flash[:notice].should eql(t(:not_found, :thing => "topic"))
    response.should redirect_to(moderator_moderations_path)
  end
end