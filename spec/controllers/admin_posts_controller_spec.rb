require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::PostsController, "non-admins" do
  fixtures :users, :user_levels
  
  it "should not be allowed in if not logged in" do
    get 'index'
    response.should redirect_to(root_path)
  end
  
end

describe Admin::PostsController, "admins" do
  fixtures :users, :user_levels, :posts, :ips
  
  before do
    login_as(:administrator)
    @ip = mock_model(Ip)
    @post = mock_model(Post)
    @posts = [@post]
  end
  
  it "should be able to find all posts created by a specific IP" do
    Ip.should_receive(:find).and_return(@ip)
    @ip.should_receive(:posts).and_return(@posts)
    get 'index', :ip_id => 1
  end
  
  it "should not be able to find posts created by an imaginary IP" do
    Ip.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
    get 'index', :ip_id => 1234567890
    flash[:notice].should_not be_nil
    response.should redirect_to(admin_root_path)
  end
  
end
