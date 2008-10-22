require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::ForumsController do
  fixtures :users, :user_levels, :forums
  
  describe Admin::ForumsController, "not an admin" do
  
    it "should not let anonymous do anything" do
      get 'index'
      response.should redirect_to(root_path)
    end
  
    it "should not allow logged in users to do anything" do
      login_as(:plebian)
      get 'index'
      response.should redirect_to(root_path)
    end
  
    it "should not allow moderators to do anything" do
      login_as(:moderator)
      get 'index'
      response.should redirect_to(root_path)
    end
  end

  describe Admin::ForumsController, "admins" do
  
    before do
      @forum = mock("forum")
      @forums = [@forum]
      login_as(:administrator)
    end
  
    it "should be able to begin making a new forum" do
      Forum.should_receive(:new).and_return(@forum)
      Forum.should_receive(:find).with(:all, :order => "title").and_return(@forums)
      get 'new'
      response.should_not redirect_to(login_path)
    end
  
    it "should create a new forum" do
      Forum.should_receive(:new).and_return(@forum)
      @forum.should_receive(:save).and_return(true)
      post 'create', { :forum => { :title => "Brand New Forum", :description => "Oh Yeah!"} }
      response.should redirect_to(admin_forums_path)
    end
  
    it "should not create a forum with invalid parameters" do 
      Forum.should_receive(:new).and_return(@forum)
      @forum.should_receive(:save).and_return(false)
      Forum.should_receive(:find).with(:all, :order => "title")
      post 'create', { :forum => { } }
      flash[:notice].should_not be_blank
      response.should render_template("new")
    end
  
    it "should be able to show the index" do
      Forum.should_receive(:find_all_without_parent).and_return(@forums)
      get 'index'
    end
  
    it "should be able to begin to edit a forum" do
      Forum.should_receive(:find).with("1").and_return(@forum)
      Forum.should_receive(:find).with(:all, :order => "title").and_return(@forums)
      @forum.should_receive(:descendants).and_return(@forums)
      get 'edit', :id => 1 
    end
    
    it "should not be able to edit a forum that does not exist" do
      Forum.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      get 'edit', :id => 123456789
      flash[:notice].should_not be_nil
      response.should redirect_to(admin_forums_path)
    end  
  
    it "should be able to update a forum" do
      Forum.should_receive(:find).with("1").and_return(@forum)
      @forum.should_receive(:update_attributes).and_return(true)
      put 'update', { :id => 1, :forum => { :title => "Title", :description => "description"}}
      flash[:notice].should_not be_nil
      response.should redirect_to(admin_forums_path)
    end
  
    it "shouldn't be able to update a forum with invalid attributes" do
      Forum.should_receive(:find).with("1").and_return(@forum)
      @forum.should_receive(:update_attributes).and_return(false)
      put 'update', { :id => 1, :forum => { :title => "", :description => "" }}
    end
  
    it "should be able to destroy a forum" do
      Forum.should_receive(:find).with("1").and_return(@forum)
      @forum.should_receive(:destroy).and_return(true)
      delete 'destroy', { :id => 1 }
    end
  
    it "should be able to move a forum up" do
      Forum.should_receive(:find).and_return(@forum)
      @forum.should_receive(:move_higher).and_return(true)
       put 'move_up', { :id => 2 }
       response.should redirect_to(admin_forums_path)
    end
    
     it "should be able to move a forum down" do
      Forum.should_receive(:find).and_return(@forum)
      @forum.should_receive(:move_lower).and_return(true)
       put 'move_down', { :id => 2 }
       response.should redirect_to(admin_forums_path)
    end
    
     it "should be able to move a forum to the top" do
      Forum.should_receive(:find).and_return(@forum)
      @forum.should_receive(:move_to_top).and_return(true)
       put 'move_to_top', { :id => 2 }
       response.should redirect_to(admin_forums_path)
    end
    
     it "should be able to move a forum to the bottom" do
      Forum.should_receive(:find).and_return(@forum)
      @forum.should_receive(:move_to_bottom).and_return(true)
       put 'move_to_bottom', { :id => 2 }
       response.should redirect_to(admin_forums_path)
    end
  end
end
