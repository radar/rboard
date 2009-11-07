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
  # Set up the permissions
  # Also sets up admin user
  Permission.make(:registered_users)
  Permission.make(:anonymous)

  # The anonymous user
  User.make_with_group(:anonymous, "Anonymous")

  # Create the user
  User.make_with_group(:registered_user, "Registered Users")
  
  category = Category.make(:public)
  
  category.forums.make(:public)
end