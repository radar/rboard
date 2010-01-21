require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::RanksController do
  before do
    setup_user_base
    setup_forums
  end

  describe "non-admins" do

    it "should not be allowed in if not logged in" do
      get 'index'
      response.should redirect_to(root_path)
    end

    it "should be denied access if logged in as a non_admin" do
      login_as(:registered_user)
      get 'index'
      response.should redirect_to(root_path)
    end


  end

  describe "admins" do

    before do
      login_as(:administrator)
      @rank = mock_model(Rank)
      @ranks = [@rank]
      @god = Rank("God")
    end


    it "should be able to begin to create a new rank" do
      Rank.should_receive(:new).and_return(@rank)
      get 'new'
    end

    it "should be able to create a rank" do
      post 'create', { :rank => { :name => "Slave", :posts_required => 5} }
      response.should redirect_to(admin_ranks_path)
      flash[:notice].should_not be_blank
    end

    it "shouldn't be able to create an invalid rank" do
      post 'create', { :rank => { :name => "", :posts_required => 5} }
      response.should render_template("new")
      flash[:notice].should_not be_blank
    end

    it "should be able to begin to edit a rank" do
      get 'edit', { :id => @god.id }
      response.should render_template("edit")
    end

    it "should be able to update a rank" do
      put 'update', { :id => @god.id, :rank => { :name => "Slave" }}
      flash[:notice].should_not be_nil
      response.should redirect_to(admin_ranks_path)
    end

    it "shouldn't be able to update a rank with invalid attributes" do
      put 'update', { :id => @god.id, :rank => { :name => "" } }
      response.should render_template("edit")
    end

    it "should be able to destroy a rank" do
      delete 'destroy', { :id => @god.id }
      flash[:notice].should_not be_blank
      response.should redirect_to(admin_ranks_path)
    end

    it "shouldn't be able to destroy a non-existant rank" do
      Rank.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      delete 'destroy', { :id => @god.id }
      flash[:notice].should_not be_blank
      response.should redirect_to(admin_ranks_path)
    end

    it "should be able to show all ranks" do
      Rank.should_receive(:find).with(:all).and_return(@ranks)
      get 'index'
    end

  end

end
