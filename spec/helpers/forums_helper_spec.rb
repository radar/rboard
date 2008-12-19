require File.dirname(__FILE__) + '/../spec_helper'
describe ForumsHelper, "general" do
  include ForumsHelper
  fixtures :forums
  
  before do
    @everybody = forums(:everybody)
    @sub_of_everybody = forums(:sub_of_everybody)
  end
  
  it "should correctly output breadcrumbs" do
    breadcrumb(@everybody).should eql(" <a href=\"/forums/218098324\">General Discussion!</a>")
    breadcrumb(@sub_of_everybody).should eql(" <a href=\"/forums/218098324\">General Discussion!</a> -> <a href=\"/forums/384866746\">Unmoderated Discussion</a>")
  end
end  
