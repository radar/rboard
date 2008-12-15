require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::IpsController do
  fixtures :users, :ips
 
  before do
    login_as(:administrator)
    @user = mock_model(User)
    @users = [@user]
    @ip = mock_model(Ip)
    @ips = [@ip]
    User.should_receive(:find).twice.and_return(@user)
    @user.stub!(:per_page).and_return(30)
    @user.stub!(:update_attribute)
    @user.stub!(:time_zone)
    @user.should_receive(:admin?).and_return(true)
  end
 
  it "should show the ips for a specific user" do
    @user.should_receive(:ips).and_return(@ips)
    @ips.should_receive(:find).with(:all, :include => [:topics, :posts]).and_return(@ips)
    get 'index', :user_id => 1
  end
  
  it "should show a specific ip" do
    Ip.should_receive(:find).with("1", :include => [:topics, :posts]).and_return(@ips)
    get 'show', :id => 1
  end
end

describe Admin::IpsController, "when asked about an imaginary user" do
  fixtures :users
  before do
    login_as(:administrator)
    @user = mock_model(User)
    User.should_receive(:find).with(:first, :conditions => { :id => users(:administrator).id }).and_return(@user)
    @user.stub!(:per_page).and_return(30)
    @user.stub!(:update_attribute)
    @user.stub!(:time_zone)
    @user.stub!(:admin?).and_return(true)
  end
  
  
  it "should not be able to find ips for an imaginary user" do
    User.should_receive(:find_by_permalink).with(1234567890).and_raise(ActiveRecord::RecordNotFound)
    get 'index', :user_id => 1234567890
    flash[:notice].should eql(t(:user_not_found))
    response.should redirect_to(admin_users_path)
  end
    
end
