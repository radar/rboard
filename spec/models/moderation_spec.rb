require File.dirname(__FILE__) + '/../spec_helper'
describe Moderation, "general" do
  before do
    setup_user_base
    @public = Forum.make(:public)
    @sub_of_public = Forum.make(:sub_of_public)
    @moderation = Moderation.make
    @moderation.moderated_object = valid_topic_for(@public)
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
    @moderation.moderated_object.forum.should_not eql(@sub_of_public)
    @moderation.move!(@public.id)
    @moderation.moderated_object.reload
    @moderation.moderated_object.forum.should eql(@public)
  end

end