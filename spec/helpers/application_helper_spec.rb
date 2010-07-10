require File.dirname(__FILE__) + '/../spec_helper'

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

  it "should accept quotes with single quotes around the name" do
    parse_text("[quote='Radar']This is a quote[/quote]").should eql("<div class=\"quote\"><strong>Radar wrote:</strong><br /><span>This is a quote</span></div>")
  end

  it "should accept quotes with double quotes around the name" do
    parse_text("[quote=\"Radar\"]This is a quote[/quote]").should eql("<div class=\"quote\"><strong>Radar wrote:</strong><br /><span>This is a quote</span></div>")
  end

  it "should correctly display multiple nested quotes" do
    parse_text('[quote="Kitten"][quote="Dog"][quote="Turtle"]turtle, turtle[/quote]QUOTE INSIDE[/quote]QUOTE OUTSIDE[/quote]').should eql("<div class=\"quote\"><strong>Kitten wrote:</strong><br /><span><div class=\"quote\"><strong>Dog wrote:</strong><br /><span><div class=\"quote\"><strong>Turtle wrote:</strong><br /><span>turtle, turtle</span></div>QUOTE INSIDE</span></div>QUOTE OUTSIDE</span></div>")
  end
  
  context "javascript injection attacks" do
    before(:each) do
      @javascript = %q(<script type="text/javascript">window.alert('lol I hacked ur boards & stuff');</script>)
      @escaped = %q(&lt;script type=&quot;text/javascript&quot;&gt;window.alert('lol I hacked ur boards &amp; stuff');&lt;/script&gt;)
    end
    
    it "should be prevented in normal posts" do
      parse_text(@javascript).should eql(@escaped)
    end
    
    it "should be prevented in quote body text" do
      @quoted = parse_text('[quote="Hacker"]I\'m gonna do something bad & awesome: ' + @javascript + '[/quote]')
      @quoted.should eql('<div class="quote"><strong>Hacker wrote:</strong><br /><span>I\'m gonna do something bad &amp; awesome: ' + @escaped + '</span></div>')
    end
    
    it "should be prevented in the content after a nested quote" do
      @endquote = parse_text('So I\'m just gonna leave this here... [quote="Lol"][quote="John"]I think this is great![/quote]Me too!' + @javascript + '[/quote]')
      @endquote.should eql('So I\'m just gonna leave this here... <div class="quote"><strong>Lol wrote:</strong><br /><span><div class="quote"><strong>John wrote:</strong><br /><span>I think this is great!</span></div>Me too!' + @escaped + '</span></div>')
    end
    
    it "should be prevented in the content before a nested quote" do
      @startquote = parse_text('So I\'m just gonna leave this here... [quote="Lol"]' + @javascript + '[quote="John"]I think this is great![/quote]Me too![/quote]')
      @startquote.should eql('So I\'m just gonna leave this here... <div class="quote"><strong>Lol wrote:</strong><br /><span>' + @escaped + '<div class="quote"><strong>John wrote:</strong><br /><span>I think this is great!</span></div>Me too!</span></div>')
    end
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
