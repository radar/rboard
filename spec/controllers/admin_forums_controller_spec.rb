require File.dirname(__FILE__) + '/../spec_helper'

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
      
    end
      
  end
  
end
