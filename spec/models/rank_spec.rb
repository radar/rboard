require File.dirname(__FILE__) + '/../spec_helper'
describe Rank, "general" do
  fixtures :ranks, :users
  
  before do
    @rank = ranks(:god)
    @user = users(:plebian)
  end
  
  it "should unassign all users" do
    @rank.users.should_not be_empty
    @user = @rank.users.first
    @user.rank.should eql("God")
    @user.rank.should_not be_nil
    @rank.destroy
    @user.reload
    @user.rank.should eql("Runner")
  end
  
  it "should be able to find a rank for a specific user" do
    Rank.for_user(@user).should eql(ranks(:runner))
  end
  
  
end