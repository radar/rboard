Given /^I have auto subscriptions turned off$/ do
  @user.update_attribute("auto_subscribe", false)
end
