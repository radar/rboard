Given /^I can see inactive forums$/ do
  @global_permission.update_attribute(:can_see_inactive_forums, true)
end

Given /^I cannot (\w+) topics$/ do |permission|
  @global_permission.update_attribute("can_#{permission}_topics", false)
end
