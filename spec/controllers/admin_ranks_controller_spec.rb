require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::RanksController, "non-admins" do
  fixtures :users
  
  it "should not be allowed in if not logged in" do
    get 'index'
    response.should redirect_to("login")
  end
  
  it "should be denied access if logged in" do
    login_as(:plebian)
    get 'index'
    response.should redirect_to("login")
  end
  
  
end

describe Admin::RanksController do
  fixtures :users, :ranks
  
  before do
    login_as(:administrator)
    @rank = mock("rank")
    @ranks = mock("ranks")
  end
  

  it "should be able to begin to create a new rank" do
    Rank.should_receive(:new).and_return(@rank)
    get 'new'
  end
  
  it "should be able to create a rank" do
    Rank.should_receive(:new).and_return(@rank)
    @rank.should_receive(:save).and_return(true)
    @rank.should_receive(:name).and_return("Slave")
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
    Rank.should_receive(:find).with("1").and_return(@rank)
    get 'edit', { :id => 1 }
  end
  
  it "should be able to update a rank" do
    Rank.should_receive(:find).with("1").and_return(@rank)
    @rank.should_receive(:update_attributes).and_return(true)
    @rank.should_receive(:name).and_return("Slave")
    put 'update', { :id => 1, :rank => { :name => "Slave" }}
    flash[:notice].should_not be_nil
    response.should redirect_to(admin_ranks_path)
  end
  
  it "shouldn't be able to update a forum with invalid attributes" do
    Rank.should_receive(:find).with("1").and_return(@rank)
    @rank.should_receive(:name).and_return("Slave")
    @rank.should_receive(:update_attributes).and_return(false)
    put 'update', { :id => 1, :rank  => { :name => "" } }
    response.should render_template("edit")
  end
  
  it "should be able to destroy a rank" do
    Rank.should_receive(:find).with("1").and_return(@rank)
    @rank.should_receive(:destroy).and_return(@rank)
    @rank.should_receive(:name).and_return("God")
    delete 'destroy', { :id => 1 }
    flash[:notice].should_not be_blank
    response.should redirect_to(admin_ranks_path)
  end
  
  it "shouldn't be able to destroy a non-existant rank" do
    Rank.should_receive(:find).with("1").and_raise(ActiveRecord::RecordNotFound)
    delete 'destroy', { :id => 1 }
    flash[:notice].should_not be_blank
    response.should redirect_to(admin_ranks_path)
  end
  
  it "should be able to show all ranks" do
    Rank.should_receive(:find).with(:all).and_return(@ranks)
    get 'index'
  end

end
