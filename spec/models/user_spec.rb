require File.dirname(__FILE__) + '/../spec_helper'
describe User, "firstly..." do
  fixtures :themes

  #regressional test
  it "should automatically set theme_id when a new user is created" do
    @user = User.new(:login => "Tester1", :password => "testing", :password_confirmation => "testing", :email => "tester@awesome.com")
    @user.save.should_not be_false
    @user.theme_id.should_not be_nil
  end
  
end

describe User, "with users" do
  fixtures :themes, :users, :ranks
  
  before do
    @user = users(:administrator)
    @other_user = users(:moderator)
    @plebian = users(:plebian)
    @banned_noob = users(:banned_noob)
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
  
  it "should be able to tell if the user is banned" do
    @user.banned?.should be_false
    @banned_noob.banned?.should be_true
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
  
  it "should see that the user was recently online" do
    @plebian.online?.should be_true
  end
  
end