Given /I am on the new user page/ do
  visits "/users/signup"
end

Given /I am on the users page/ do
  visits "/users"
end

Given /I am logged in as (.*) who is a[n]? (.*)/ do |login, user_level|
  @user = Factory.create(:admin)
  visits "/login"  
  fills_in("login", :with => "admin")  
  fills_in("password", :with => "password")  
  clicks_button("Login")
end
