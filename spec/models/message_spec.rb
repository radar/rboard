require File.dirname(__FILE__) + '/../spec_helper'
describe Message, "general stuff" do
  fixtures :users, :messages
  before do
    @user = users(:administrator)
  end
  
  it "should be able to find the correct number of inbox messages" do
    @user.inbox_messages.size.should eql(2)
  end
end