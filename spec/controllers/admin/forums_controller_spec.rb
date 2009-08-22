require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ForumsController do
  fixtures :users, :forums, :permissions, :groups, :group_users, :categories
  
  describe Admin::ForumsController, "not an admin" do
  
    it "should not let anonymous do anything" do
      get 'index'
      flash[:notice].should eql(t(:need_to_be_admin))
      response.should redirect_to(root_path)
    end
  
    it "should not allow logged in users to do anything" do
      login_as(:plebian)
      get 'index'
      flash[:notice].should eql(t(:need_to_be_admin))
      response.should redirect_to(root_path)
    end
  
    it "should not allow moderators to do anything" do
      login_as(:moderator)
      get 'index'
      flash[:notice].should eql(t(:need_to_be_admin))
      response.should redirect_to(root_path)
    end
    
    it "should not be able to manage the forums" do
      login_as(:administrator)
      user = users(:administrator)
      user.permissions.global.update_attribute(:can_manage_forums, false)
      get 'index'
      flash[:notice].should eql(t(:not_allowed_to_manage, :area => "forums"))
      response.should redirect_to(admin_root_path)
    end
  end

  describe Admin::ForumsController, "admins" do
    
    before do
      login_as(:administrator)
      @forum = mock_model(Forum)
      @forums = [@forum]
      @category = mock_model(Category)
      @test_category = categories(:test)
    end
    
    
    it "should be able go to the index action" do
      get 'index'
      response.should render_template("index")
    end
    
    it "should be able to begin to create a forum" do
      get 'new'
      response.should render_template("new")
    end
    
    it "should be able to begin to create a forum in the test category" do
      get 'new', :category_id => @test_category.id
      response.should render_template("new")
    end
    
    it "should be able to create a new forum" do
      post 'create', :forum => { :title => "This is a forum", :description => "description" }
      response.should redirect_to(admin_forums_path)
      flash[:notice].should eql(t(:created, :thing => "Forum"))
    end
    
    it "should not be able to create a forum with invalid attributes" do
      post 'create', :forum => { :title => "" }
      response.should render_template("new")
      flash[:notice].should eql(t(:not_created, :thing => "forum"))
    end
    
    it "should be able to create a forum for a category" do
      post 'create', { :forum => { :title => "This is a forum for a category", :description => "This is a description" }, :category_id => categories(:test).id }
      response.should redirect_to(admin_forums_path)
      flash[:notice].should eql(t(:created, :thing => "Forum"))
    end
    
    it "should be able to edit a forum" do
      get 'edit', :id => forums(:admins_only).id
      response.should render_template("edit")
    end
    
    it "should not be able to edit a forum that does not exist" do
      get 'edit', :id => 1234567890
      flash[:notice].should eql(t(:not_found, :thing => "forum"))
      response.should redirect_to(admin_forums_path)
    end
    
    it "should be able to update a forum" do
      put 'update', {:id => forums(:admins_only).id, :forum => { :title => "Title" }}
      response.should redirect_to(admin_forums_path)
      flash[:notice].should eql(t(:updated, :thing => "forum"))
    end
    
    it "should not be able to update a forum with invalid attributes" do
      put 'update', { :id => forums(:admins_only).id, :forum => { :title => "" }}
      response.should render_template("edit")
      flash.now[:notice].should eql(t(:not_updated, :thing => "forum"))
    end
    
    it "should be able to destroy a forum" do
      delete 'destroy', :id => forums(:admins_only).id 
      response.should redirect_to(admin_forums_path)
      flash[:notice].should eql(t(:deleted, :thing => "forum"))
    end
  
    it "should be able to move a category upwards" do
      put 'move_up', :id => forums(:admins_only).id
    end

    it "should be able to move a category downwards" do
      put 'move_down', :id => forums(:admins_only).id
    end

    it "should be able to move a category to the top" do
      put 'move_to_top', :id => forums(:admins_only).id
    end

    it "should be able to move a category to the bottom" do
      put 'move_to_bottom', :id => forums(:admins_only).id
    end
    
      
  end
  
end
