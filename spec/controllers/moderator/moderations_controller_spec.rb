require File.dirname(__FILE__) + '/../../spec_helper'

describe Moderator::ModerationsController do
  fixtures :users, :moderations, :topics, :posts, :forums, :groups, :group_users, :permissions

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
      get 'index'
      response.should render_template("index")
    end

    it "should be able to create a moderation" do
      post 'create', :topic_id => topics(:moderator)
      response.should render_template("create")
    end

    it "should try to create a moderation, but finding it there should destroy it" do
      post 'create', :topic_id => topics(:user)
      response.should render_template("destroy")
    end

    it "should be able to begin to edit a moderation" do
      get 'edit', :id => moderations(:first).id
      response.should render_template("edit")
    end

    it "should not be able to edit a moderation that does not exist" do
      get 'edit', :id => 123456789
      response.should redirect_to(moderator_moderations_path)
      flash[:notice].should eql(t(:not_found, :thing => "moderation"))
    end

    it "should be able to update a moderation" do
      put 'update', { :id => moderations(:first).id, :moderation => { :reason => "Because." } }
      flash[:notice].should eql(t(:updated, :thing => "moderation"))
      response.should redirect_to(moderator_moderations_path)
    end
  end
end