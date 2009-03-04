require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::RanksController, "non-admins" do
  fixtures :users
  
  it "should not be allowed in if not logged in" do
    get 'index'
    response.should redirect_to(root_path)
  end
  
  it "should be denied access if logged in as a non_admin" do
    login_as(:plebian)
    get 'index'
    response.should redirect_to(root_path)
  end
  
  
end

describe Admin::RanksController do
  fixtures :users, :ranks
  
  before do
    login_as(:administrator)
    @rank = mock_model(Rank)
    @ranks = [@rank]
    @god = ranks(:god)
  end
  

  it "should be able to begin to create a new rank" do
    Rank.should_receive(:new).and_return(@rank)
    get 'new'
  end
  
  it "should be able to create a rank" do
    Rank.should_receive(:new).and_return(@rank)
    @rank.should_receive(:save).and_return(true)
    post 'create', { :rank => { :name => "Slave", :posts_required => 5} }
    response.should redirect_to(admin_ranks_path)
    flash[:notice].should_not be_blank
  end
  
  it "shouldn't be able to create an invalid rank" do
    Rank.should_receive(:new).and_return(@rank)
    @rank.should_receive(:save).and_return(false)
    post 'create', { :rank => { :name => "", :posts_required => 5} }
    response.should render_template("new")
    flash[:notice].should_not be_blank
  end
  
  it "should be able to begin to edit a rank" do
    Rank.should_receive(:find).and_return(@rank)
    get 'edit', { :id => @god.id }
  end
  
  it "should be able to update a rank" do
    Rank.should_receive(:find).and_return(@rank)
    @rank.should_receive(:update_attributes).and_return(true)
    put 'update', { :id => @god.id, :rank => { :name => "Slave" }}
    flash[:notice].should_not be_nil
    response.should redirect_to(admin_ranks_path)
  end
  
  it "shouldn't be able to update a rank with invalid attributes" do
    Rank.should_receive(:find).and_return(@rank)
    @rank.should_receive(:update_attributes).and_return(false)
    put 'update', { :id => @god.id, :rank => { :name => "" } }
    response.should render_template("edit")
  end
  
  it "should be able to destroy a rank" do
    Rank.should_receive(:find).and_return(@rank)
    @rank.should_receive(:destroy).and_return(@rank)
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
