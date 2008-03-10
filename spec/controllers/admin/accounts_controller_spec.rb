require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AccountsController do
  fixtures :users

  before do
    @user = mock("user")
    @users = [@user]
    @banned_ip = mock("banned_ip")
    @banned_ips = [@banned_ips]
    
  end
  
  it "should redirect non-admins away" do
    get 'index', {}, { :user => 3 }
    response.should redirect_to("login")
    flash[:notice].should_not be_blank
    get 'index', {}, { :user => 2}
    response.should redirect_to("login")
    flash[:notice].should_not be_blank
    get 'index', {}, { :user => 1}
    response.should_not redirect_to("login")
    flash[:notice].should be_blank
  end
  
  
  it "should be able to ban an ip" do
    BannedIp.should_receive(:find).and_return(@banned_ips)
    BannedIp.should_receive(:create).and_return(@banned_ip)
    post 'ban_ip', { :banned_ip => { :ban_time => Time.now + 5.minutes, :ip => "127.0.0.1", :banned_by => 1 }}, { :user => 1}
  end
end