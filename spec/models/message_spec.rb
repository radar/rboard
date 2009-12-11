require File.dirname(__FILE__) + '/../spec_helper'
describe Message, "general stuff" do
  before do
    setup_user_base
    @user = User("administrator")
    @user.inbox_messages.make
    @user.inbox_messages.make
    @message = @user.inbox_messages.first
  end

  it "should be able to find the correct number of inbox messages" do
    @user.inbox_messages.size.should eql(2)
  end

  it "should check if a user owns a message" do
    @message.belongs_to?(User("moderator")).should eql(false)
    @message.belongs_to?(User("registered_user")).should eql(true)
    @message.belongs_to?(User("administrator")).should eql(true)
  end
end