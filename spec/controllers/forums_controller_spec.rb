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
    @everybody = forums(:everybody)
    @admins_only = forums(:admins_only)
  end
  
  def find_forums
    Category.should_receive(:find).and_return(@category)
    @category.should_receive(:forums).and_return(@forums)
    @forums.should_receive(:without_parent).and_return(@forums)
    @forums.should_receive(:active).and_return(@forums)
  end
  
  describe "plebian" do
    before do
      # We do all this should_receive'ing to test what it's like for a specific user
      login_as(:plebian)
    end
    
    it "should be able to see a list of forums and categories" do
      Category.should_receive(:without_parent).and_return(@categories)
      Forum.should_receive(:without_category).and_return(@forums)
      @forums.should_receive(:without_parent).and_return(@forums)
      get 'index'
      response.should render_template("index")
    end
    
    it "should show a list of forums inside a specific category" do
      find_forums
      get 'index', :category_id => @test_category.id
      response.should render_template("index")
    end
    
    it "should not be able to see anything inside a restricted category" do
      get 'index', :category_id => @admin_category.id
      flash[:notice].should eql(t(:category_permission_denied))
      response.should redirect_to(root_path)
    end
    
    it "should be able to see the everybody forum" do
      get 'show', :id => @everybody.id
      response.should render_template("show")
    end
    
    it "should not be able to see the admins only forum" do
      get 'show', :id => @admins_only.id
      flash[:notice].should eql(t(:forum_permission_denied))
      response.should redirect_to(forums_path)
    end
    
  end
  
  describe "admin" do
    before do
      login_as(:administrator)
    end
    
    it "should be able to see the everybody forum" do
      get 'show', :id => @everybody.id
      response.should render_template("show")
    end
    
    it "should be able to see the admins only forum" do
      get 'show', :id => @admins_only.id
      response.should render_template("show")
    end
    
    it "should be able to see forums for the test category" do
      find_forums
      get 'index', :category_id => @test_category.id
      response.should render_template("index")
    end
    
    it "should be able to see the forums for the admin category" do
      find_forums
    get 'index', :category_id => @admin_category.id
      response.should render_template("index")
    end
  end
  
end
