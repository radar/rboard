Given /there is a forum called (.*)/ do |title|
  Forum.create(:title => title, :description => Faker::Lorem.words(1))
end

Given /I am on the forums index page/ do 
  visit forums_path
end

Then /I should see (.*)/ do |text|
  response.body.match(text)
end