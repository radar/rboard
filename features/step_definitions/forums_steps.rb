Given /^there is an inactive forum$/ do
  Forum.create(:title => "Hidden Forum", :description => "This is a hidden forum", :active => false)
end