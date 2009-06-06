require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::MembersController do
  fixtures :users, :groups, :group_users
  
  it "should be able to assign a user to a group" do
    post 'create', { :group_id => groups(:administrators).id, :user => users(:plebian).login }
    flash[:notice].should eql(t(:has_been_placed_into, :user => users(:plebian), :group => groups(:administrators)))
    response.should redirect_to(admin_group_users_path(groups(:administrators)))
  end
  
  it "should not be able to assign a user who doesn't exist to a group" do
    post 'create', { :group_id => groups(:administrators).id, :user => "non-existant" }
    flash[:notice].should eql(t(:not_found, :thing => "user"))
    response.should redirect_to(admin_group_users_path(groups(:administrators)))
  end
  
  it "should be able to remove a user from a group" do
    delete 'destroy', { :group_id => groups(:registered_users), :id => users(:plebian).login }
    flash[:notice].should eql(t(:has_been_removed, :user => users(:plebian).id, :group => groups(:registered_users).to_s))
    response.should redirect_to(admin_group_users_path(groups(:registered_users)))
  end

end
