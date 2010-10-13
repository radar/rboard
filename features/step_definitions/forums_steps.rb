Given /^there is an inactive forum$/ do
  Forum.create(:title => "Hidden Forum", :description => "This is a hidden forum", :active => false)
end

Given /^there is a closed forum$/ do
  user = User.first
  localhost = Ip.make(:localhost)
  forum = Forum.create!(:title => "Closed Forum", :description => "This is a closed forum", :open => false)
  topic = forum.topics.build(:subject => "Closed Forum's Topic", :user => user, :ip => localhost)
  topic.posts.build(:text => "I live in the Closed Forum. All by myself.", :user => user, :ip => localhost)
  topic.save!
end

Then /^I should be in the "([^\"]*)" forum$/ do |title|
  forum = Forum.find_by_title(title)
  current_url.should include forum_path(forum)
end
