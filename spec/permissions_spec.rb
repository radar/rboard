require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe User, "with given permissions" do
  fixtures :permissions, :users, :groups, :forums, :group_users
  
  before do
    @user = users(:administrator)
    @forum = forums(:admins_only)
  end
  
  it "should be able to see a forum" do
    puts @user.groups.first.permissions.inspect
    @user.can?(:see_forum).should be_true
    @user.can?(:see_forum, @forum).should be_true
  end
  
end