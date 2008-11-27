Given /^I am on the forums page$/ do
  visits "/forums"
end

Given /^I am on the forum page for "(.*)"$/ do |title|
  forum = Forum.find_by_title(title)
  visits "/forums/#{Forum.find_by_title(title).id}"
end

Given /there are forums/ do
  Factory(:admin_forum)
  Factory(:moderator_forum)
  Factory(:user_forum)
end