require File.dirname(__FILE__) + '/../spec_helper'
describe ApplicationHelper, "general" do
  fixtures :forums, :categories
  include ApplicationHelper
  
  before do
    @everybody = forums(:everybody)
    @sub_of_everybody = forums(:sub_of_everybody)
  end
  
  it "should correctly output breadcrumbs" do
    breadcrumb(@everybody).should eql("<a href=\"/categories/914358341/forums\">test</a> -> <a href=\"/forums/218098324\">General Discussion!</a>")
    breadcrumb(@sub_of_everybody).should eql("<a href=\"/categories/914358341/forums\">test</a> -> <a href=\"/forums/218098324\">General Discussion!</a> -> <a href=\"/forums/384866746\">Unmoderated Discussion</a>")
  end
  
  it "should correctly encapsulate double quotes" do
    bbcode('[quote="Kitten"][quote="Dog"]QUOTE INSIDE[/quote]QUOTE OUTSIDE[/quote]').should eql("<div class='center'><div class='quote'><b>Kitten wrote:</b><div class='center'><div class='quote'><b>Dog wrote:</b></div></div>QUOTE OUTSIDE</div></div>")
  end
end  
