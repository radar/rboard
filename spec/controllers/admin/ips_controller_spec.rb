require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::IpsController do

  before do
    setup_user_base
    login_as(:administrator)
  end

  it "should show the ips for a specific user" do
    get 'index', :user_id => "registered_user"
    response.should render_template("index")
  end

  it "should show a specific ip" do
    get 'show', :id => Ip.make.id, :user_id => "registered_user"
    response.should render_template("show")
  end

  it "should not be able to find ips for an imaginary user" do
    get 'index', :user_id => 1234567890
    flash[:notice].should eql(t(:not_found, :thing => "user"))
    response.should redirect_to(admin_users_path)
  end  

end