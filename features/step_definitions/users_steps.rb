Given /^I can see inactive forums$/ do
  @permission = @user.permissions.global
  @permission.update_attribute(:can_see_inactive_forums, true)
end
