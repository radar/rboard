def setup_user_base
  # The anonymous user
  User.make_with_group(:anonymous, "Anonymous")
  registered_user_group = Group.make(:registered_users)

  # Set up the permissions
  # Also sets up admin user
  Permission.make(:registered_users)
  Permission.make(:anonymous)

  # Create the users
  User.make_with_group(:registered_user, "Registered Users")
  User.make_with_group(:banned_noob, "Registered Users")

  # And the people who control it all
  moderator     = User.make_with_group(:moderator, "Moderators")
  administrator = User.make_with_group(:administrator, "Administrators")
  administrator.groups -= [Group.find_by_name("Registered Users")]
  administrator.save!

  registered_user_group.owner = administrator
  registered_user_group.save

  Permission.make(:administrators)
  Permission.make(:moderators)
end

def setup_forums
  # Categories
  category = Category.make(:public)
  admins_only_category = Category.make(:name => "Admin Walled Garden")

  # Categorized forum
  forum = category.forums.make(:public)

  # Subforums
  Forum.make(:sub_of_public)
  Forum.make(:sub_of_sub_of_public)

  # A couple of topics for forum

  3.times { valid_topic_for(forum, 3) }


  # Decategorized forum

  decategorized_forum = Forum.make(:title => "Another Forum")

  # Topic for decategorized forum

  valid_topic_for(decategorized_forum)

  # Admin forum

  admin_forum = admins_only_category.forums.make(:title => "Admins Only")

  valid_topic_for(admin_forum)

  # Moderator forum

  moderator_forum = Forum.make(:title => "Moderators Only")

  valid_topic_for(moderator_forum)

  # Various permissions
  Permission.make(:administrators, :forum => admin_forum)
  Permission.make(:anonymous, :forum => admin_forum, :can_see_forum => false)
  Permission.make(:moderators, :forum => admin_forum, :can_see_forum => false)
  Permission.make(:registered_users, :forum => admin_forum, :can_see_forum => false)

  Permission.make(:anonymous, :category => admins_only_category, :can_see_category => false)
  Permission.make(:registered_users, :category => admins_only_category, :can_see_category => false)
end

def valid_topic_for(forum, posts_count=1)
  topic = forum.topics.make_unsaved

  posts_count.to_i.times do
    post = topic.posts.build(Post.plan)
    post.user = User.ensure(:administrator)
  end

  topic.tap(&:save!)
end