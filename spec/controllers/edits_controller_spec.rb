 require File.dirname(__FILE__) + '/../spec_helper'

describe EditsController do

  before do
    setup_user_base
    setup_forums
    @public = Forum.make(:public)
    valid_topic_for(@public)
    @public.reload
    @post = @public.posts.first
    @edit = @post.edits.create
    @invisible_edit = @post.edits.create(:hidden => true)

    @admin_forum = Forum("Admins Only")
    @admin_post = @admin_forum.posts.first
    @admin_edit = @admin_post.edits.create
  end

  describe EditsController, "as plebian" do

    before do
      login_as(:registered_user)
    end

    it "should not be able to go to the index action" do
      get 'index'
      response.should redirect_to(root_path)
      flash[:notice].should_not be_nil
    end

    it "should not be able to see an invisible edit" do
      get 'show', :id => @invisible_edit, :post_id => @admin_post
    end
  end

  describe EditsController, "as a person with access to edits" do
    before do
      login_as(:moderator)
    end

    it "should not be able to go to the index action if a post is not specified" do
      get 'index'
      flash[:notice].should eql(t(:not_found, :thing => "post"))
      response.should redirect_to(root_path)
    end

    it "should be able to see a single edit" do
      get 'show', :post_id => @post.id, :id => @edit.id
      response.should render_template("show")
    end

    it "should not be able to see an edit for a post they do not have access to" do
      get 'show', :post_id => @admin_post.id, :id => @admin_edit.id
      flash[:notice].should eql(t(:forum_object_permission_denied, :object => "post"))
      response.should redirect_to(root_path)
    end

    it "should not be able to see an edit that does not exist" do
      get 'show', :post_id => @post.id, :id => 123456789
      response.should redirect_to(root_path)
      flash[:notice].should eql(t(:not_found, :thing => "edit"))
    end
  end
end
