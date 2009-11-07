# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def bbcode(text)
    # Code snippets
    text.gsub!(/\[code=?["']?(.*?)["']?\](.*?)\[\/code\]/mis) { CodeRay.scan($2.strip, ($1.blank? ? :plain : $1.to_sym)).div(:line_numbers => :table)}
    text = sanitize(text, :tags => %w(span div table tr td br pre tt), :attributes => %w(id class style))
    # Gist embedding
    text.gsub!(/\[gist\](.*?)\[\/gist\]/) { $1.split(" ").map { |gist| "<script src='http://gist.github.com/#{gist}.js'></script>" } }

    # allows for nested quotes
    bbquote(text)

    # non-attributed quote
    text.gsub!(/\[quote\](.*?)\[\/quote\]/mis) { "<div class='center'><div class='quote'>" << $1 << "</div></div>" }

    # Terminal example
    text.gsub!(/\[term\](.*?)\[\/term\]/mi) { "<span class='term'>" << $1.gsub(/^\r\n/,"").gsub("<","&lt;").gsub(">","&gt;") << "</span>" }

    # URLs
    text.gsub!(/\[url=["']?(.*?)["']?\](.*?)\[\/url\]/mis) { "<a rel='nofollow' href='" << $1 << "'>" << $2 << "</a>" }

    # handle with care...
    bbcode_ext(text)
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
      o = "<img src='#{ActionController::Base.relative_url_root}/themes/" + theme.name + "/#{f}'"
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

  def menu_for_topic
    links = []
    if logged_in? 
      if current_user.can?(:start_new_topics, @forum) 
        links << link_to(t(:New, :thing => "Topic"), new_forum_topic_path(@forum))
      end 

      if (@topic.locked? && current_user.can?(:reply_to_locked_topics)) || (!@topic.locked? && current_user.can?(:reply_to_topics)) &&
         (!@forum.open? && current_user.can?(:post_in_closed_forums) || @forum.open?)  
        links << link_to(t(:New, :thing => "Reply"), new_topic_post_path(@topic)) 
      end 

      if current_user.can?(:lock_topics, @forum) || (current_user.can?(:lock_own_topics, @forum) && @topic.belongs_to?(current_user)) 
     	 links << if @topic.locked?  
          link_to(t(:Unlock_this_topic), unlock_forum_topic_path(@forum, @topic), :method => :put)
     	 else 
       	 link_to(t(:Lock_this_topic), lock_forum_topic_path(@forum, @topic), :method => :put)
        end 
      end 

      if current_user.can?(:edit_topics, @forum) || (current_user.can?(:edit_own_topics, @forum) && @topic.belongs_to?(current_user)) 
        links << link_to(t(:Edit_topic), edit_forum_topic_path(@forum))
      end 

      if current_user.can?(:subscribe, @forum) 
     	  links << if @subscription 
           link_to(t(:Unsubscribe), topic_subscription_path(@topic, @subscription), :method => :delete)
         else 
           link_to(t(:Subscribe), topic_subscriptions_path(@topic), :method => :post)
     	  end 
      end 

    links.join(" | ")
    else 
      if @topic.locked? 
        t(:Locked!) 
      end 
    end 
  end
end
