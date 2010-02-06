require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PostsController do
  before do
    setup_user_base
    setup_forums
  end

  describe "non-admins" do
    it "should not be allowed in if not logged in" do
      get 'index'
      response.should redirect_to(root_path)
    end
  end

  describe "admins" do
    fixtures :users, :posts, :ips, :permissions, :group_users, :groups

    before do
      login_as(:administrator)
    end

    it "should be able to find all posts created by a specific IP" do
      get 'index', :ip_id => Ip.make(:localhost)
      response.should render_template("index")
    end

    it "should not be able to find posts created by an imaginary IP" do
      get 'index', :ip_id => 1234567890
      flash[:notice].should eql(t(:not_found, :thing => "ip"))
      response.should redirect_to(admin_root_path)
    end

  end
end