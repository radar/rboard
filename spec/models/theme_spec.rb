require File.dirname(__FILE__) + '/../spec_helper'
describe Theme, "general" do
  fixtures :themes
  
  before do
    @theme = themes(:blue)
  end
  
  it "should load the stylesheet" do
    @theme.to_s.should eql(File.readlines("#{RAILS_ROOT}/public/themes/blue/style.css").to_s)
  end
  
end