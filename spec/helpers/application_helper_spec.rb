require File.dirname(__FILE__) + '/../spec_helper'

class TestView < ActionView::Base
  include ApplicationHelper
end

describe ApplicationHelper, "general" do
  include ApplicationHelper
  extend ActionView::Helpers::SanitizeHelper::ClassMethods

  before do
    setup_user_base
    setup_forums
    @everybody = Forum("Public Forum")
    @sub_of_everybody = @everybody.children.first
  end

  it "should correctly output breadcrumbs" do
    breadcrumb(@everybody).should eql("<a href=\"/categories/#{@everybody.category.id}/forums\">Public Category</a> &raquo; <a href=\"/forums/#{@everybody.id}\">Public Forum</a>")
    breadcrumb(@sub_of_everybody).should eql("<a href=\"/categories/#{@everybody.category.id}/forums\">Public Category</a> &raquo; <a href=\"/forums/#{@everybody.id}\">Public Forum</a> &raquo; <a href=\"/forums/#{@sub_of_everybody.id}\">Sub of Public Forum</a>")
  end
  
  it "should correctly display multiple nested quotes" do
    TestView.new.parse_text('[quote="Kitten"][quote="Dog"][quote="Turtle"]turtle, turtle[/quote]QUOTE INSIDE[/quote]QUOTE OUTSIDE[/quote]').should eql("<div class='quote'><b>Kitten wrote:</b><br /><span><div class='quote'><b>Dog wrote:</b><br /><span><div class='quote'><b>Turtle wrote:</b><br /><span>turtle, turtle</span></div>QUOTE INSIDE</span></div>QUOTE OUTSIDE</span></div>")
  end
  
  it "correctly formats the bbcode when it contains some code blocks" do
    parse_text("[img]http://www.google.com.au/intl/en_au/images/logo.gif[/img]
    <Radar> *egotripping*
    [code]
    <div class='posts listing'>Hi!</div>
    <div class='posts listing'>Hi!</div>

    <div class='posts listing'>Hi!</div>
    [/code]").should eql("<img src='http://www.google.com.au/intl/en_au/images/logo.gif'>\n    &lt;Radar&gt; *egotripping*\n    <strong>Code:</strong><pre>\n    &lt;div class='posts listing'&gt;Hi!&lt;/div&gt;\n    &lt;div class='posts listing'&gt;Hi!&lt;/div&gt;\n\n    &lt;div class='posts listing'&gt;Hi!&lt;/div&gt;\n    </pre>")
  end
end  
