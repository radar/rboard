require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::TopicsController, "non-admins" do
  fixtures :users
  
  it "should not be allowed in if not logged in" do
    get 'index'
    response.should redirect_to(root_path)
  end
  
end

describe Admin::TopicsController, "admins" do
  fixtures :users, :topics, :ips
  
  before do
    login_as(:administrator)
    @ip = mock_model(Ip)
    @topic = mock_model(Topic)
    @topics = [@topic]
  end
  
  it "should be able to find all topics created by a specific IP" do
    Ip.should_receive(:find).and_return(@ip)
    @ip.should_receive(:topics).and_return(@topics)
    get 'index', :ip_id => 1
  end
  
  it "should not be able to find topics created by an imaginary IP" do
    Ip.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
    get 'index', :ip_id => 1234567890
    flash[:notice].should_not be_nil
    response.should redirect_to(admin_root_path)
  end
  
  
end
