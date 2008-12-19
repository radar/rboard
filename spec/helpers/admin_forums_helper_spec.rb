require File.dirname(__FILE__) + '/../spec_helper'
describe Admin::ForumsHelper, "general" do
  include Admin::ForumsHelper
  fixtures :forums
  
  before do
    @everybody = forums(:everybody)
    @sub_of_everybody = forums(:sub_of_everybody)
  end
  
  it "should correctly output forums" do
    select_display(@everybody).should eql("General Discussion!")
    select_display(@sub_of_everybody).should eql("--Unmoderated Discussion")
  end
end  
