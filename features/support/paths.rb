module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the homepage/
      '/'
      
    when /the admin forums page/
      admin_forums_path      
    when /administrator's group page/
      admin_groups_path
      
    when /the new topic page for "(.*?)"/
      new_forum_topic_path(Forum.find_by_title($1))
    
    when /the reply page for the first topic in "(.*?)"/
      f = Forum.find_by_title($1)
      new_topic_post_path(f.topics.first)
      
    when /the forums page/
      forums_path
    when /the forum page for "(.*?)"/
      forum_path(Forum.find_by_title($1))
    when /login page/
      login_path
    
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
