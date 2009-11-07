require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::TopicsController do
  fixtures :users, :topics, :ips, :groups, :group_users, :permissions

  describe "non-admins" do

    it "should not be allowed in if not logged in" do
      get 'index'
      response.should redirect_to(root_path)
    end
  end

  describe "admins" do

    before do
      login_as(:administrator)
      @ip = mock_model(Ip)
      @topic = mock_model(Topic)
      @topics = [@topic]
    end

    it "should be able to find all topics created by a specific IP" do
      get 'index', :ip_id => ips(:localhost).id
      response.should render_template("index")
    end

    it "should not be able to find topics created by an imaginary IP" do
      Ip.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      get 'index', :ip_id => 1234567890
      flash[:notice].should_not be_nil
      response.should redirect_to(admin_root_path)
    end
  end


end
