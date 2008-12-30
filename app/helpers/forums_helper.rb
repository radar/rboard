module ForumsHelper
   def breadcrumb(forum, breadcrumb='')
    breadcrumb = ''
    if forum.parent.nil?
      breadcrumb += link_to(forum.category.name, category_path(forum.category)) + ' ->' if forum.category
      breadcrumb += ' ' + link_to(forum.title, forum_path(forum))
    else
      breadcrumb += " #{breadcrumb(forum.parent)} -> " + link_to(forum.title, forum_path(forum))
    end
    breadcrumb.strip
  end
end
