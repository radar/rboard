Given /^I am logged in as "([^\"]*)"$/ do |user|
  Given "I am on the homepage"
  When "I follow \"Login\""
  When "I fill in \"login\" with \"#{user}\""
  When "I fill in \"password\" with \"password\""
  When "I press \"Login\""
  Then "I should see \"Logged in successfully.\""
  # To get the latest user
  @user = User.first(:order => "updated_at DESC")
  @global_permission = @user.permissions.global
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
  @global_permission = @user.permissions.global
end

Given /^there is the usual setup$/ do
  User.delete_all
  # We *would* use the install code for this, but this sets up just a bit more than that.

  # Configuration
   Configuration.create(:key => "subforums_display", :title => I18n.t(:subforums_display), :value => 3, :description => I18n.t(:subforums_display_description))

  setup_user_base
  setup_forums
end