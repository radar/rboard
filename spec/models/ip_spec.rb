require File.dirname(__FILE__) + '/../spec_helper'
describe Ip, "general" do
  fixtures :ips

  before do
    @ip = Ip.make(:ip => "127.0.0.1")
  end

  it "should convert the Ip object to a string" do
    @ip.to_s.should eql("127.0.0.1")
  end


end