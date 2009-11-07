require File.dirname(__FILE__) + '/../spec_helper'
describe Rank, "general" do
  before do
    Rank.make(:runner)
    @rank = Rank.make(:god)
    @user = User.make(:registered_user)
    @user.rank = @rank
    @user.save!
    @rank.reload
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
    Rank.for_user(@user).should eql(Rank.find_by_name("Runner"))
  end


end