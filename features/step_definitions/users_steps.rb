Given /^I can see inactive forums$/ do
  @permission = @user.permissions.global
  @permission.update_attribute(:can_see_inactive_forums, true)
end


Given /^"([^\"]*)"'s password is set to nil$/ do |login|
  u = User.find_by_login(login) || User.make(login.to_sym)
  u.crypted_password = nil
  u.save(false).should be_true
end

Then /^"([^\"]*)"'s password should now be set$/ do |login|
  u = User.find_by_login(login)
  u.crypted_password.should_no
  t be_nil
end
