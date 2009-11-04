require File.dirname(__FILE__) + '/../spec_helper'

class TestView < ActionView::Base
  include ApplicationHelper
end

describe ApplicationHelper, "general" do
  fixtures :forums, :categories
  include ApplicationHelper
  
  before do
    @everybody = forums(:everybody)
    @sub_of_everybody = forums(:sub_of_everybody)
  end
  
  it "should correctly output breadcrumbs" do
    breadcrumb(@everybody).should eql("<a href=\"/categories/#{@everybody.category.id}/forums\">test</a> -> <a href=\"/forums/#{@everybody.id}\">General Discussion!</a>")
    breadcrumb(@sub_of_everybody).should eql("<a href=\"/categories/#{@everybody.category.id}/forums\">test</a> -> <a href=\"/forums/#{@everybody.id}\">General Discussion!</a> -> <a href=\"/forums/#{@sub_of_everybody.id}\">Unmoderated Discussion</a>")
  end
  
  it "should correctly encapsulate double quotes" do
    TestView.new.parse_text('[quote="Kitten"][quote="Dog"]QUOTE INSIDE[/quote]QUOTE OUTSIDE[/quote]').should eql("<div class='center'><div class='quote'><b>Kitten wrote:</b><div class='center'><div class='quote'><b>Dog wrote:</b></div></div>QUOTE OUTSIDE</div></div>")
  end
end  
