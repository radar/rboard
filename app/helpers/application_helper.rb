# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def bbcode(text)
    
    #cool stuff (well, at least I think so)
    text.gsub!(/\[code=?["']?(.*?)["']?\](.*?)\[\/code\]/mis) { "<div class='code'><b>" << $1 << "</b><br />" << code_highlight($2) << "</div>" }
    text.gsub!(/\[quote=?["']?(.*?)["']?\](.*?)\[\/quote\]/mis) { "<div class='align_center'><div class='quote'><b>" << $1 << " wrote:</b><br />" << $2 << "</div></div>" }
    text.gsub!(/\[quote\](.*?)\[\/quote\]/mis) { "<div class='align_center'><div class='quote'>" << $1 << "</div></div>" }
    text.gsub!(/\[term\](.*?)\[\/term\]/m) { "<span class='term'>" << $1.gsub(/^\r\n/,"").gsub("<","&lt;").gsub(">","&gt;") << "</span>" }
    text.gsub!(/\[url=["']?(.*?)["']?\](.*?)\[\/url\]/mis) { "<a href='" << $1 << "'>" << $2 << "</a>" }
    text.gsub!(/\[topic=["']?(.*?)["']?\](.*?)\[\/topic\]/mis) { "<a href='/topics/show/" << $1 << "'>" << $2  << "</a>" }

    text
  end
  def code_highlight(code)
    convertor = Syntax::Convertors::HTML.for_syntax "ruby"
    code = code_layout(convertor.convert(code))
  end
  def code_layout(code)
    code.gsub!(/<\/?pre>/,"")
    lines = code.split("\r\n")
    output = "<table cellspacing='0' cellpadding='0' width='100%'>"
    for i in 1..lines.size-1
      output << "<tr><td class='line-num' valign='top'>" << i.to_s << "</td><td class='line'>" << lines[i] << "</td></tr>"
    end
    output << "</table>"
  end
  def theme_image_tag(f, html_options={})
    if !theme.nil?
      o = "<img src='#{ActionController::AbstractRequest.relative_url_root}/themes/" + theme.name + "/#{f}'"
      html_options.each { |option| o << "#{option.first}='#{option.last}'"}
      o << " />"
    else
      image_tag "/#{f}", html_options 
    end
    
  end
end
