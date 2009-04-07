 require File.dirname(__FILE__) + '/../spec_helper'

describe EditsController do
  fixtures :users, :posts, :topics, :edits, :group_users, :groups, :permissions, :forums
  
  before do
    @post = posts(:user)
    @edit = edits(:user)
    @admin_post = posts(:admin)
    @admin_edit = edits(:admin)
    @invisible_edit = edits(:invisible)
  end
  
  describe EditsController, "as plebian" do
    
    before do
      login_as("plebian")
    end
    
    it "should not be able to go to the index action" do
      get 'index'
      response.should redirect_to(root_path)
      flash[:notice].should_not be_nil
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
    
    it "should be able to go to the index action" do
      get 'index', :post_id => @post.id
      response.should render_template("index")
    end
    
    it "should be able to see a single edit" do
      get 'show', :post_id => @post.id, :id => @edit.id
      response.should render_template("show")
    end
    
    it "should not be able to see an edit for a post they do not have access to" do
      get 'show', :post_id => @admin_post.id, :id => @admin_edit.id
      flash[:notice].should eql(t(:forum_post_permission_denied))
      response.should redirect_to(root_path)
    end
    
    it "should not be able to see an edit that does not exist" do
      get 'show', :post_id => @post.id, :id => 123456789
      response.should redirect_to(root_path)
      flash[:notice].should eql(t(:not_found, :thing => "edit"))
    end
  
    it "should be able to see an invisible edit" do
      Post.should_receive(:find).and_return(@post)
      @post.should_receive(:edits).and_return(@edits)
      @edits.should_receive(:find).and_return(@edit)
      get 'show', :id => @invisible_edit, :post_id => @admin_post
    end 
  end
end
