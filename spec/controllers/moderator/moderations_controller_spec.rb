require File.dirname(__FILE__) + '/../../spec_helper'

describe Moderator::ModerationsController do
  before do
    setup_user_base
    setup_forums
  end

  describe Moderator::ModerationsController, "a user" do
    before do
      login_as(:registered_user)
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
      @moderator = User(:moderator)
      @forum = Forum("Public Forum")
      @topic = @forum.topics.first
    end

   def create_moderation
     @topic.moderations.create!(:user => @moderator)
   end

    it "should be able to see the index page" do
      get 'index'
      response.should render_template("index")
    end

    it "should be able to create a moderation" do
      post 'create', :topic_id => @topic
      response.should render_template("create")
    end

    it "should try to create a moderation, but finding it there should destroy it" do
      create_moderation
      post 'create', :topic_id => @topic
      response.should render_template("destroy")
    end

    it "should be able to begin to edit a moderation" do
      moderation = create_moderation
      get 'edit', :id => moderation
      response.should render_template("edit")
    end

    it "should not be able to edit a moderation that does not exist" do
      get 'edit', :id => 123456789
      response.should redirect_to(moderator_moderations_path)
      flash[:notice].should eql(t(:not_found, :thing => "moderation"))
    end

    it "should be able to update a moderation" do
      moderation = create_moderation
      put 'update', { :id => moderation, :moderation => { :reason => "Because." } }
      flash[:notice].should eql(t(:updated, :thing => "moderation"))
      response.should redirect_to(moderator_moderations_path)
    end
  end
end