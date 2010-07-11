class RboardHtmlMaker < RbbCode::HtmlMaker
  # Note that the calls to #content_tag in this class
  # do NOT call the rails helper method, but rather 
  # the method as defined in RbbCode::HtmlMaker.
  
  def html_from_gist_tag(node)
    content_tag(:script, node.inner_bb_code, :src => 'http://gist.github.com/').html_safe
  end
  
  def html_from_quote_tag(node)
    content = ''.html_safe
    inner_html = ''.html_safe
    
    node.children.each do |child|
      inner_html << make_html(child).html_safe
    end

    if node.value.blank?
      content << content_tag(:strong, "Quote:").html_safe
      content << content_tag(:div, inner_html, :class => 'quote').html_safe
    else
      name = node.value.gsub(/^['"]/,'').gsub(/['"]$/,'')
      content << content_tag(:div, (
        content_tag(:strong, "#{name} wrote:").html_safe +
        "<br />".html_safe + 
        content_tag(:span, inner_html).html_safe
        ).html_safe, :class => 'quote').html_safe
    end

    content
  end

  def html_from_term_tag(node)
    content_tag(:span, node.inner_bb_code, :class => 'term').html_safe
  end
end