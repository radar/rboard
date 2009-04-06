require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::PostsController, "non-admins" do
  fixtures :users
  
  it "should not be allowed in if not logged in" do
    get 'index'
    response.should redirect_to(root_path)
  end
  
end

describe Admin::PostsController, "admins" do
  fixtures :users, :posts, :ips, :permissions, :group_users, :groups
  
  before do
    login_as(:administrator)
    @ip = mock_model(Ip)
    @post = mock_model(Post)
    @posts = [@post]
  end
  
  it "should be able to find all posts created by a specific IP" do
    get 'index', :ip_id => ips(:localhost).id
    response.should render_template("index")
  end
  
  it "should not be able to find posts created by an imaginary IP" do
    get 'index', :ip_id => 1234567890
    flash[:notice].should eql(t(:ip_not_found))
    response.should redirect_to(admin_root_path)
  end
  
end
