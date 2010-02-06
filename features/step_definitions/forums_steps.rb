Given /^there is an inactive forum$/ do
  Forum.create(:title => "Hidden Forum", :description => "This is a hidden forum", :active => false)
end

Given /^there is a closed forum$/ do
  f = Forum.create!(:title => "Closed Forum", :description => "This is a closed forum", :open => false)
  t = f.topics.build(:subject => "Closed Forum's Topic", :user => User.first)
  t.posts.build(:text => "I live in the Closed Forum. All by myself.", :user => User.first)
  t.save!
end

Then /^I should be in the "([^\"]*)" forum$/ do |title|
  Forum.find(ActionController::Routing::Routes.recognize_path(request.path, { :method => :get })[:forum_id]).title.should eql(title)
end
