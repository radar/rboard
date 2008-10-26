require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::UsersController, "as an admin" do
  fixtures :users, :banned_ips, :user_levels

  before do
    login_as(:administrator)
    @user = mock("user")
    @users = [@user]
    @banned_ip = mock("banned_ip")
    @banned_ips = [@banned_ips]
    @rank = mock("rank")
    @ranks = [@rank]
    @user_level = mock("user_level")
    @user_levels = [@user_level]
    @posts = [mock("posts")]
  end
  
  it "should redirect standard users away" do
    login_as(:plebian)
    get 'index'
    response.should redirect_to(root_path)
    flash[:notice].should_not be_blank
  end
  
  it "should redirect moderators away" do
    login_as(:moderator)
    get 'index'
    response.should redirect_to(root_path)
    flash[:notice].should_not be_blank
  end
  
  it "should allow admins free reign" do
    get 'index'
    response.should_not redirect_to(root_path)
    flash[:notice].should be_blank
  end
  
  it "should be able to begin banning an ip" do
    BannedIp.should_receive(:new).and_return(@banned_ip)
    get 'ban_ip'
  end
  
  
  it "should be able to ban an ip" do
    BannedIp.should_receive(:find).twice.and_return(@banned_ips)
    BannedIp.should_receive(:new).and_return(@banned_ip)
    @banned_ip.should_receive(:save).and_return(true)
    post 'ban_ip', :banned_ip => { :ban_time => Time.now + 5.minutes, :ip => "127.0.0.1" }
    flash[:notice].should_not be_blank
  end
  
  it "should not be able to ban an invalid ip, such as those seen in crappy hollywood movies" do
    BannedIp.should_receive(:find).twice.and_return(@banned_ips)
    BannedIp.should_receive(:new).and_return(@banned_ip)
    @banned_ip.should_receive(:save).and_return(false)
    post 'ban_ip', :banned_ip => { :ban_time => Time.now + 5.minutes, :ip => "444.232.342.123" }
    flash[:notice].should_not be_blank
  end
  
  it "should be able to begin to ban a user" do
    User.should_receive(:find).and_return(@user)
    get 'ban', :id => users(:administrator).id, :user => { } 
  end
  
  it "should give a message if they try to ban themselves" do
    User.should_receive(:find).and_return(users(:administrator))
    get 'ban', :id => users(:administrator).id, :user => { } 
    flash[:notice].should_not be_nil
  end
  
  it "should be able to ban a user" do
    User.should_receive(:find).and_return(@user)
    @user.should_receive(:update_attributes).and_return(true)
    @user.should_receive(:increment!).with("ban_times").and_return(true)
    put 'ban', :id => 1, :user => { }
  end
  
  it "should be able to edit a user" do
    User.should_receive(:find).and_return(@user)
    get 'edit', :id => 1
  end
  
  it "should be able to update a user" do 
    User.should_receive(:find).and_return(@user)
    @user.should_receive(:update_attributes).with({"signature"=>"Woot!"}).and_return(true)
    put 'update', :id => 1, :user => { :signature => "Woot!"}
    flash[:notice].should_not be_blank
  end
  
  it "should not be able to update a user with invalid params" do
    User.should_receive(:find).twice.and_return(@user)
    @user.should_receive(:update_attributes).and_return(false)
    put 'update', :id => users(:banned_noob), :user => { :time_display => "" }
    flash[:notice].should_not be_blank
  end
  
  it "should be able to remove a banned ip" do
    get 'remove_banned_ip', { :id => banned_ips(:localhost) }
    flash[:notice].should_not be_blank
    response.should redirect_to(ban_ip_admin_users_path)
  end
  
  it "should be able to look up a user's details" do
    User.should_receive(:find_by_login).and_return(@user)
    @user.should_receive(:posts).and_return(@posts)
    get 'user', :id => "Administrator"
  end
  
 
end