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
    
    # attributed quote
    bbquote(text)
    
    # non-attributed quote
    text.gsub!(/\[quote\](.*?)\[\/quote\]/mis) { "<div class='center'><div class='quote'>" << $1 << "</div></div>" }
    
    # Terminal example
    text.gsub!(/\[term\](.*?)\[\/term\]/mi) { "<span class='term'>" << $1.gsub(/^\r\n/,"").gsub("<","&lt;").gsub(">","&gt;") << "</span>" }
    
    # URLs
    text.gsub!(/\[url=["']?(.*?)["']?\](.*?)\[\/url\]/mis) { "<a href='" << $1 << "'>" << $2 << "</a>" }
    # bbcode_ext(textilize(text))
    
    # handle with care...
    text 
  end
  
  # Dummy method so that people can extend bbcode method without having to alias it.
  def bbcode_ext(text)
    text
  end
  
  def bbquote(text)
    text.gsub!(/\[quote=["']?(.*?)["']?\](.*)\[\/quote\]/mis) do
      "<div class='center'><div class='quote'>#{$1.empty? ? "" : "<b>#{$1} #{t(:wrote)}</b>"}#{bbquote($2)}</div></div>"
    end
  end
  
  
  def theme_image_tag(f, html_options={})
    if !theme.nil?
      o = "<img src='/themes/" + theme.name + "/#{f}'"
      html_options.each { |option| o << "#{option.first}='#{option.last}'"}
      o << " />"
    else
      image_tag "/#{f}", html_options 
    end
  end
  
   def breadcrumb(forum, breadcrumb='')
    breadcrumb = ''
    if forum.parent.nil?
      breadcrumb += link_to(forum.category.name, category_forums_path(forum.category)) + ' ->' if forum.category
      breadcrumb += ' ' + link_to(forum.title, forum_path(forum))
    else
      breadcrumb += " #{breadcrumb(forum.parent)} -> " + link_to(forum.title, forum_path(forum))
    end
    breadcrumb.strip
  end
end
