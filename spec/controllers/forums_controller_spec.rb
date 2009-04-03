require File.dirname(__FILE__) + '/../spec_helper'

describe ForumsController do
  fixtures :users, :forums, :categories, :groups, :group_users, :permissions 
  
  before do
    @category = mock_model(Category)
    @categories = [@category]
    @forum = mock_model(Forum)
    @forums = [@forum]
    @test_category = categories(:test)
    @admin_category = categories(:admins_only)
  end
  
  describe "plebian" do
    before do
      login_as(:plebian)
    end
    
    it "should be able to see a list of forums and categories" do
      Category.should_receive(:without_parent).and_return(@categories)
      Forum.should_receive(:without_category).and_return(@forums)
      @forums.should_receive(:without_parent).and_return(@forums)
      get 'index'
    end
    
    it "should show a list of forums inside a specific category" do
      Category.should_receive(:find).and_return(@category)
      @category.should_receive(:forums).and_return(@forums)
      @forums.should_receive(:without_parent).and_return(@forums)
      get 'index', :category_id => @test_category.id
    end
    
    it "should not be able to see anything inside a restricted category" do
      get 'index', :category_id => @admin_category.id
      flash[:notice].should eql(t(:category_permission_denied))
      response.should redirect_to(root_path)
    end
    
  end
  
end
