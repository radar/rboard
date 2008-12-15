require File.dirname(__FILE__) + '/../spec_helper'
describe Ip, "general" do
  fixtures :ips
  
  before do
    @ip = ips(:localhost)
  end
  
  it "should update the updated_at timestamp on find" do
    @ip.updated_at.should_not be_nil
  end
  
  it "should convert the Ip object to a string" do
    @ip.to_s.should eql("127.0.0.1")
  end
  
  
end