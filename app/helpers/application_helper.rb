# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def inside_layout layout = 'application', &block
    render :inline => capture_haml(&block), :layout => "layouts/#{layout}"
  end

  def parse_text(text)
    parser = RbbCode::Parser.new(:html_maker => RboardHtmlMaker.new)
    text = parser.parse(text).html_safe

    # handle with care...
    bbcode_ext(text)
  end

  # Dummy method so that people can extend bbcode method without having to alias it.
  def bbcode_ext(text)
    text
  end

  def theme_image_tag(f, html_options={})
    if !theme.nil?
      o = "<img src='/themes/" + theme.name + "/#{f}'"
      html_options.each { |option| o << "#{option.first}='#{option.last}'"}
      o << " />"
    else
      image_tag "/#{f}", html_options
    end.html_safe
  end

  def stripe
    cycle("odd", "even")
  end

  def breadcrumb(forum, breadcrumb='')
    breadcrumb = ''
    if forum.parent.nil?
      breadcrumb += link_to(forum.category.name, category_forums_path(forum.category)) + raw(" &raquo;") if forum.category
      breadcrumb += ' ' + link_to(forum.title, forum_path(forum))
    else
      breadcrumb += " #{breadcrumb(forum.parent)}" + raw(" &raquo;")
      breadcrumb += ' ' + link_to(forum.title, forum_path(forum))
    end
    breadcrumb.html_safe.strip
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
    ('<div class="buttons">' + buttons.join(" / ") + ' </div><div class="actions">' + links.join(" / ") + '</div>').html_safe
    else
      if @topic.locked?
        t(:Locked!)
      end
    end
  end
end
