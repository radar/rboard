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

  describe "plebian" do
    before do
      # We do all this should_receive'ing to test what it's like for a specific user
      login_as(:plebian)
    end

    it "should not be able to see anything inside a restricted category" do
      get 'index', :category_id => @admin_category.id
      flash[:notice].should eql(t(:category_permission_denied))
      response.should redirect_to(root_path)
    end

    it "should not be able to see the admins only forum" do
      get 'show', :id => @admins_only.id
      flash[:notice].should eql(t(:forum_permission_denied))
      response.should redirect_to(forums_path)
    end

  end
end
