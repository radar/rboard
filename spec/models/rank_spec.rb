require File.dirname(__FILE__) + '/../spec_helper'
describe Rank, "general" do
  fixtures :ranks, :users
  
  before do
    @rank = ranks(:god)
  end
  
  it "should unassign all users" do
    @rank.users.should_not be_empty
    @rank.unassign_all_users
    @rank.reload
    @rank.users.should be_empty
  end
  
  
end