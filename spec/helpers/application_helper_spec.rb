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

  it "discerns between paragraphs and line breaks" do
    @paras = parse_text("So this line is part of the first paragraph.\nThis line is too, but it's on a new line!\n\nNow I'm in the second paragraph.\n \n And I'm a couple of lines down in the second para.")
    @paras.should eql("<p>So this line is part of the first paragraph.<br/>This line is too, but it's on a new line!</p><p>Now I'm in the second paragraph.<br/> <br/> And I'm a couple of lines down in the second para.</p>")
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
  
  context "html injection attacks" do
    it "should be prevented when the user manually escapes HTML" do
      @lolscaped = %q(I'm not doing anything bad, honest! &lt;/div&gt;Ok, well maybe I am.)
      @escaped = %q(I'm not doing anything bad, honest! &amp;lt;/div&amp;gt;Ok, well maybe I am.)
    end
  end
  
  context "javascript injection attacks" do
    before(:each) do
      @javascript = %q(<script type="text/javascript">window.alert('lol I hacked ur boards');</script>)
      @escaped = %q(&lt;script type="text/javascript"&gt;window.alert('lol I hacked ur boards');&lt;/script&gt;)
    end
    
    it "should be prevented in normal posts" do
      parse_text(@javascript).should eql("<p>#{@escaped}</p>")
    end
    
    it "should be prevented in quote body text" do
      @quoted = parse_text('[quote="Hacker"]I\'m gonna do something bad: ' + @javascript + '[/quote]')
      @quoted.should eql('<div class="quote"><strong>Hacker wrote:</strong><br /><span>I\'m gonna do something bad: ' + @escaped + '</span></div>')
    end
    
    it "should be prevented in the content after a nested quote" do
      @endquote = parse_text('So I\'m just gonna leave this here... [quote="Lol"][quote="John"]I think this is great![/quote]Me too!' + @javascript + '[/quote]')
      @endquote.should eql('<p>So I\'m just gonna leave this here... </p><div class="quote"><strong>Lol wrote:</strong><br /><span><div class="quote"><strong>John wrote:</strong><br /><span>I think this is great!</span></div>Me too!' + @escaped + '</span></div>')
    end
    
    it "should be prevented in the content before a nested quote" do
      @startquote = parse_text('So I\'m just gonna leave this here... [quote="Lol"]' + @javascript + '[quote="John"]I think this is great![/quote]Me too![/quote]')
      @startquote.should eql('<p>So I\'m just gonna leave this here... </p><div class="quote"><strong>Lol wrote:</strong><br /><span>' + @escaped + '<div class="quote"><strong>John wrote:</strong><br /><span>I think this is great!</span></div>Me too!</span></div>')
    end
    
    it "should be prevented in a url" do
      @url = parse_text('[url=javascript:function(){window.alert("lol I hacked ur boards");return false;}]Somewhere amazing[/url]')
      @url.should eql('<p><a href="">Somewhere amazing</a></p>')
    end
  end

  it "correctly formats the bbcode when it contains some code blocks" do
    parse_text("[img]http://www.google.com.au/intl/en_au/images/logo.gif[/img]
    <Radar> *egotripping*
    [code]
    <div class='posts listing'>Hi!</div>
    <div class='posts listing'>Hi!</div>

    <div class='posts listing'>Hi!</div>
    [/code]").should eql("<p><img src=\"http://www.google.com.au/intl/en_au/images/logo.gif\" alt=\"\"/><br/>    &lt;Radar&gt; *egotripping*<br/>    <pre><code>\n    &lt;div class='posts listing'&gt;Hi!&lt;/div&gt;\n    &lt;div class='posts listing'&gt;Hi!&lt;/div&gt;\n\n    &lt;div class='posts listing'&gt;Hi!&lt;/div&gt;\n    </code></pre></p>")
  end
end  
