Given /^I am logged in as "([^\"]*)"$/ do |user|
  Given "I am on the homepage"
  When "I follow \"Login\""
  When "I fill in \"login\" with \"#{user}\""
  When "I fill in \"password\" with \"password\""
  When "I press \"Login\""
  Then "I should see \"Logged in successfully.\""
  # To get the latest user
  @user = User.first(:order => "updated_at DESC")
end

Given /^I am logged in as "([^\"]*)" with the password "([^\"]*)"$/ do |user, password|
  Given "I am on the homepage"
  When "I follow \"Login\""
  When "I fill in \"login\" with \"#{user}\""
  When "I fill in \"password\" with \"#{password}\""
  When "I press \"Login\""
  Then "I should see \"Logged in successfully.\""
  # To get the latest user
  @user = User.first(:order => "updated_at DESC")
end

Given /^there is the usual setup$/ do

  # We *would* use the install code for this, but this sets up just a bit more than that.

  # Configuration
   Configuration.create(:key => "subforums_display", :title => I18n.t(:subforums_display), :value => 3, :description => I18n.t(:subforums_display_description))

  # Set up the permissions
  # Also sets up admin user
  Permission.make(:registered_users)
  Permission.make(:anonymous)

  # The anonymous user
  User.make_with_group(:anonymous, "Anonymous")

  # Create the user
  User.make_with_group(:registered_user, "Registered Users")

  # Categories
  category = Category.make(:public)

  # Categorized forum
  forum = category.forums.make(:public)

  # Subforums
  Forum.make(:sub_of_public)
  Forum.make(:sub_of_sub_of_public)

  # Topic for forum

  valid_topic_for(forum)

  # Decategorized forum

  decategorized_forum = Forum.make(:title => "Another Forum")

  # Topic for decategorized forum

  valid_topic_for(decategorized_forum)

  # Admin forum

  admin_forum = Forum.make(:title => "Admins Only")
  Permission.make(:registered_users, :forum => admin_forum, :can_see_forum => false)
end