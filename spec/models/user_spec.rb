require File.dirname(__FILE__) + '/../spec_helper'
describe User, "general" do
  fixtures :themes, :user_levels
  #regressional test
  it "should automatically set theme_id when a new user is created" do
    @user = User.new(:login => "Tester1", :password => "testing", :password_confirmation => "testing", :email => "tester@awesome.com")
    @user.save.should_not be_false
    @user.theme_id.should_not be_nil
  end
  
  #regression test for 4481b926571fc6fe4f979912c0b8707601293a81
  it "should make the user an admin if they're the first user" do
    User.delete_all
    User.count.should eql(0)
    @user = User.new(:login => "Admin", :password => "tester", :password_confirmation => "tester", :email => "tester@admin.com")
    @user.user_level.should be_nil
    @user.save!
    @user.user_level.should eql(user_levels(:administrator))
  end
  
end