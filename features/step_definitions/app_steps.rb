Given /^I am logged in as "([^\"]*)"$/ do |user|
  Given "I am on the login page"
  When "I fill in \"login\" with \"#{user}\""
  When "I fill in \"password\" with \"password\""
  When "I press \"Login\""
  Then "I should see \"Logged in successfully.\""
end