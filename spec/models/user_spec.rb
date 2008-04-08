require File.dirname(__FILE__) + '/../spec_helper'
describe User, "general" do
  fixtures :themes
  #regressional test
  it "should automatically set theme_id when a new user is created" do
    @user = User.new(:login => "Tester1", :password => "testing", :password_confirmation => "testing", :email => "tester@awesome.com")
    @user.save.should_not be_false
    @user.theme_id.should_not be_nil
  end
  
end