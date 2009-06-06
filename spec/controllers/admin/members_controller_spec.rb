require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::MembersController do
  fixtures :users, :groups, :group_users
  
  before do
    @administrators = groups(:administrators)
    @registered_users = groups(:registered_users)
  end
  
  it "should be able to assign a user to a group" do
    post 'create', { :group_id => @administrators.id, :user => users(:plebian).login }
    flash[:notice].should eql(t(:has_been_placed_into, :user => users(:plebian), :group => @administrators))
    response.should redirect_to(admin_group_users_path(@administrators))
  end
  
  it "should not be able to assign a user who doesn't exist to a group" do
    post 'create', { :group_id => @administrators.id, :user => "non-existant" }
    flash[:notice].should eql(t(:not_found, :thing => "user"))
    response.should redirect_to(admin_group_users_path(@administrators))
  end
  
  it "should be able to remove a user from a group" do
    delete 'destroy', { :group_id => @registered_users, :id => users(:plebian).login }
    flash[:notice].should eql(t(:has_been_removed, :user => users(:plebian).id, :group => @registered_users.to_s))
    response.should redirect_to(admin_group_users_path(@registered_users))
  end
  
  it "should not be able to remove a user that doesn't exist from a group" do
    delete 'destroy', { :group_id => @registered_users, :id => 1234567890 }
    flash[:notice].should eql(t(:not_found, :thing => "user"))
    response.should redirect_to(admin_group_users_path)
  end
  
  it "should not be able to do anything to a group that doesn't exist" do
    delete 'destroy', { :group_id => 1234567890, :id => 1234567890 }
    flash[:notice].should eql(t(:not_found, :thing => "group"))
    response.should redirect_to(admin_groups_path)
  end

end
