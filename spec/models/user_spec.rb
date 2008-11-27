require File.dirname(__FILE__) + '/../spec_helper'
describe User, "firstly..." do
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
    @user.user_level.should eql(user_levels(:user))
    @user.save!
    @user.user_level.should eql(user_levels(:administrator))
  end
  
end

describe User, "with users" do
  fixtures :themes, :user_levels, :users, :ranks
  
  before do
    @user = users(:administrator)
    @other_user = users(:moderator)
    @plebian = users(:plebian)
    @god = ranks(:god)
  end
  
  it "should authenticate the user" do
    @user.authenticated?("godly").should be_true
    @user.authenticated?("mortal").should be_false
  end
  
  it "should remember a user" do
    @user.remember_token?.should be_true
  end
  
  it "should be able to remember a user" do
    @other_user.remember_token?.should be_nil
    @other_user.remember_me
    @other_user.remember_token?.should be_true
  end
  
  it "should be able to determine what kind of user a user is" do
    @user.admin?.should be_true
    @user.moderator?.should be_false
    @user.user?.should be_false
    
    @other_user.admin?.should be_false
    @other_user.moderator?.should be_true
    @other_user.user?.should be_false
    
    @plebian.admin?.should be_false
    @plebian.moderator?.should be_false
    @plebian.user?.should be_true
  end
  
  it "should be able to authenticate a user" do
    User.authenticate("Plebian", "only_human").should_not be_nil
    User.authenticate("Plebian", "wrong password").should be_nil
    User.authenticate("non-existant", "right password").should be_nil
  end
  
  it "should be able to find a rank for a user" do
    @user.rank.should eql(@god.name)
    @other_user.rank.should eql("Moderator")
  end
end