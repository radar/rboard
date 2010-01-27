require File.dirname(__FILE__) + '/../spec_helper'
describe Theme, "general" do
  fixtures :themes

  before do
    @theme = Theme.make(:name => "Blue")
  end

  it "should load the stylesheet" do
    directory = THEMES_DIRECTORY.respond_to?("call") ? THEMES_DIRECTORY.call() : THEMES_DIRECTORY
    @theme.to_s.should eql(File.readlines("#{directory}/blue/style.css").to_s)
  end

end