require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Admin::CategoriesController do
  fixtures :categories, :forums, :users, :groups, :group_users, :permissions
  
  before do
    @category = mock_model(Category)
    @categories = [@category]
    @forum = mock_model(Forum)
    @forums = [@forum]
  end
  
  describe "non-admin users" do
    it "should not be able to access this" do
      get 'index'
      response.should redirect_to(root_path)
    end
  end
  
  describe "admin users" do
    
    def find_category
      Category.should_receive(:find).with("1", :include => :forums).and_return(@category)
    end
    
    before do
      login_as(:administrator)
    end
  
    it "should be able to show a list of categories" do
      Category.should_receive(:all).with(:order => "name asc").and_return(@categories)
      get 'index'
    end
    
    it "should be able to show a single category" do
      find_category
      @category.should_receive(:forums).and_return(@forums)
      get 'show', :id => 1
    end
    
    it "should be able to begin to create a new category" do
      Category.should_receive(:new).and_return(@category)
      get 'new'
    end
    
    it "should be able to create a new category" do
      Category.should_receive(:new).and_return(@category)
      @category.should_receive(:save).and_return(true)
      post 'create', :category => { :name => "Cat E. Gori"}
      flash[:notice].should eql(t(:created, :thing => "category"))
      response.should redirect_to(admin_categories_path)
    end
    
    it "should not be able to create a new category with invalid attributes" do
      Category.should_receive(:new).and_return(@category)
      @category.should_receive(:save).and_return(false)
      post 'create', :catgory => { :name => "" }
      flash[:notice].should eql(t(:not_created, :thing => "category"))
      response.should render_template("new")
    end
    
    it "should be able to edit a category" do
      find_category
      get 'edit', :id => 1
    end
    
    it "should be able to update a category" do
      find_category
      @category.should_receive(:update_attributes).and_return(true)
      put 'update', :id => 1, :category => { :name => "Foo Bar"}
      flash[:notice].should eql(t(:updated, :thing => "category"))
      response.should redirect_to(admin_categories_path)
    end
    
    it "should not be able to update a category with invalid attributes" do
      find_category
      @category.should_receive(:update_attributes).and_return(false)
      put 'update', :id => 1, :category => { :name => "" }
      flash[:notice].should eql(t(:not_updated, :thing => "category"))
      response.should render_template("edit")
    end
    
    it "should be able to destroy a category" do
      find_category
      @category.should_receive(:destroy).and_return(@category)
      delete 'destroy', :id => 1
      flash[:notice].should eql(t(:deleted, :thing => "category"))
    end
    
    it "should be able to move a category upwards" do
      find_category
      @category.should_receive(:move_higher).and_return(true)
      put 'move_up', :id => 1
    end
    
    it "should be able to move a category downwards" do
      find_category
      @category.should_receive(:move_lower).and_return(true)
      put 'move_down', :id => 1
    end
    
    it "should be able to move a category to the top" do
      find_category
      @category.should_receive(:move_to_top).and_return(true)
      put 'move_to_top', :id => 1
    end
    
    it "should be able to move a category to the bottom" do
      find_category
      @category.should_receive(:move_to_bottom).and_return(true)
      put 'move_to_bottom', :id => 1
    end    
    
  end
  
end