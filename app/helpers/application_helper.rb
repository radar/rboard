# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # This could probably be done better.
  def bbcode(tag, start_piece, end_piece, &block)
    block.call.gsub!(%r{\[#{tag}\](.*?)\[\/#{tag}\]}) { "#{start_piece}#{$1}#{end_piece}" }
  end

  def parse_text(text)
    # Code snippets

    # All this sanitization is probably quite draining. Needs refactoring.
    if !text.include?("[code")
      # We would use h here but it escapes quotes, which we need for bbquotes.
      # This is the code it uses anyway.
      text = text.gsub(/&/, "&amp;").gsub(/>/, "&gt;").gsub(/</, "&lt;")
    end
    text.gsub!(/(.*?)\[code=?["']?(.*?)["']?\](.*?)\[\/code\](.*?)/mis) { h($1.to_s) + "[code='#{$2}']#{$3}[/code]" + h($4)}
    text.gsub!(/\[code=?["']?(.*?)["']?\](.*?)\[\/code\]/mis) { "<strong>#{t(:Code)}:</strong><pre>#{clean_code($2)}</pre>"}

    ## Quoting
    bbquote!(text)

    # Parse all similar tags
    bbcode("img", "<img src='", "'>") { text }
    bbcode("gist", "<script src='http://gist.github.com/", '></script>') { text }
    bbcode("quote", "<strong>Quote:</strong><div class='quote'>", "</div>") { text }
    bbcode("term", "<span class='term'>", "</span>") { text }

    # URLs
    text.gsub!(/\[url=["']?(.*?)["']?\](.*?)\[\/url\]/mis) { "<a rel='nofollow' href='" << $1 << "'>" << $2 << "</a>" }

    # handle newlines
    text.gsub!(/(.*)(\r)+?\n/) { $1 << "<br />\n" }

    # handle with care...
    bbcode_ext(text)
  end

  # Dummy method so that people can extend bbcode method without having to alias it.
  def bbcode_ext(text)
    text
  end

  def clean_code(text)
    text.gsub(/^\r\n/, '').gsub(/\r\n$/, '').gsub("<", "&lt;").gsub(">", "&gt;")
  end

  def bbquote!(text)
    if md = text.match( /\[\s*quote=(["'])?([^\1\]]+)(\1)\s*\](?!\[\s*quote=(["'])?([^\1\]]+)(\1)\s*\])(.*?)\[\s*\/\s*quote\s*\]/i )
      first, last = md.offset(0)[0], md.offset(0)[1]-1
      name, content = md[2], md[7]
      text[first..last] = content_tag(:div,
                                      content_tag(:strong,"%s wrote:" % name) +
                                      tag(:br) +
                                      content_tag(:span, content),
                                      :class => 'quote')
      bbquote!(text)
    else
      text
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

  def stripe
    cycle("odd", "even")
  end

  def breadcrumb(forum, breadcrumb='')
    breadcrumb = ''
    if forum.parent.nil?
      breadcrumb += link_to(forum.category.name, category_forums_path(forum.category)) + ' &raquo;' if forum.category
      breadcrumb += ' ' + link_to(forum.title, forum_path(forum))
    else
      breadcrumb += " #{breadcrumb(forum.parent)} &raquo; " + link_to(forum.title, forum_path(forum))
    end
    breadcrumb.strip
  end

  def menu_for_topic
    buttons = []
    links = []
    if logged_in?
      # Permissions checking is done in the partial.
      # This is also used in the forums/show view.
      buttons << render(:partial => "topics/new_button")

      if (@topic.locked? && current_user.can?(:reply_to_locked_topics)) || (!@topic.locked? && current_user.can?(:reply_to_topics)) &&
         (!@forum.open? && current_user.can?(:post_in_closed_forums) || @forum.open?)  
        buttons << link_to(t(:New, :thing => "Reply"), new_topic_post_path(@topic), :class => "button")
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
    '<div class="buttons">' + buttons.join(" / ") + ' </div><div class="actions">' + links.join(" / ") + '</div>'
    else 
      if @topic.locked? 
        t(:Locked!) 
      end 
    end 
  end
end
