# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def bbcode(text)
    #cool stuff (well, at least I think so)
    begin
      text.gsub!(/\[code=?["']?(.*?)["']?\](.*?)\[\/code\]/mis) { "<div class='code'>" << Uv.parse($2, "xhtml", $1, true, "lazy") << "</div>" }
    rescue NoMethodError
      text.gsub!(/\[code=?["']?(.*?)["']?\](.*?)\[\/code\]/mis) { "<div class='code'><font color='red'><strong>#{t(:invalid_syntax)}</strong></font></div>" }
    end
    text.gsub!(/</, "&lt;")
    text.gsub!(/>/, "&gt;")
    text.gsub!(/\[quote=?["']?(.*?)["']?\](.*?)\[\/quote\]/mis) { "<div class='center'><div class='quote'><b>" << $1 << " #{t(:wrote)}</b><br />" << $2 << "</div></div>" }
    text.gsub!(/\[quote\](.*?)\[\/quote\]/mis) { "<div class='center'><div class='quote'>" << $1 << "</div></div>" }
    text.gsub!(/\[term\](.*?)\[\/term\]/mi) { "<span class='term'>" << $1.gsub(/^\r\n/,"").gsub("<","&lt;").gsub(">","&gt;") << "</span>" }
    text.gsub!(/\[url=["']?(.*?)["']?\](.*?)\[\/url\]/mis) { "<a href='" << $1 << "'>" << $2 << "</a>" }
    textilize(text)
  # handle with care...

  end
  
  def theme_image_tag(f, html_options={})
    if !theme.nil?
      o = "<img src='#{RAILS_RELATIVE_URL_ROOT}/themes/" + theme.name + "/#{f}'"
      html_options.each { |option| o << "#{option.first}='#{option.last}'"}
      o << " />"
    else
      image_tag "/#{f}", html_options 
    end
    
  end
end
