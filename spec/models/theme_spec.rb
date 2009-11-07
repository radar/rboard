require File.dirname(__FILE__) + '/../spec_helper'
describe Theme, "general" do
  fixtures :themes

  before do
    @theme = Theme.make(:name => "Blue")
  end

  it "should load the stylesheet" do
    @theme.to_s.should eql(File.readlines("#{THEMES_DIRECTORY}/blue/style.css").to_s)
  end

end