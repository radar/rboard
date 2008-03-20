require File.dirname(__FILE__) + '/../spec_helper'
describe Message, "general stuff" do
  fixtures :users, :messages
  before do
    @user = users(:administrator)
    @message = messages(:one)
  end
  
  it "should be able to find the correct number of inbox messages" do
    @user.inbox_messages.size.should eql(2)
  end
  
  it "should check if a user owns a message" do
    @message.belongs_to_user(3).should eql(false)
    @message.belongs_to_user(2).should eql(true)
    @message.belongs_to_user(1).should eql(true)
  end
end