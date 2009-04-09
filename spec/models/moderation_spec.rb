require File.dirname(__FILE__) + '/../spec_helper'
describe Moderation, "general" do
  fixtures :moderations, :topics, :forums
  before do
    @moderation = moderations(:first)
    @moderation.moderated_object = topics(:moderator)
    @admin_forum = forums(:admins_only)
  end
  
  it "should lock the associated moderated item" do
    @moderation.moderated_object.locked?.should be_false
    @moderation.lock!
    @moderation.moderated_object.locked?.should be_true
  end
  
  it "should unlock the associated moderated item" do
    @moderation.moderated_object.lock!
    @moderation.moderated_object.locked?.should be_true
    @moderation.unlock!
    @moderation.moderated_object.locked?.should be_false
  end
  
  it "should sticky the associated moderated item" do
    @moderation.moderated_object.sticky?.should be_false
    @moderation.sticky!
    @moderation.moderated_object.sticky?.should be_true
  end
  
  it "should unsticky the associated moderated item" do
    @moderation.moderated_object.sticky!
    @moderation.moderated_object.sticky?.should be_true
    @moderation.unsticky!
    @moderation.moderated_object.sticky?.should be_false
  end
  
  it "should destroy the associated moderated item" do
    @moderation.destroy!
    @moderation.moderated_object.frozen?.should be_true
  end
  
  it "should move the associated moderated item" do
    @moderation.moderated_object.forum.should_not eql(@admin_forum)
    @moderation.move!(@admin_forum.id)
    @moderation.moderated_object.reload
    @moderation.moderated_object.forum.should eql(@admin_forum)
  end
  
end