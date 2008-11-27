Given /I am on the new user page/ do
  visits "/users/signup"
end

Given /I am on the users page/ do
  visits "/users"
end

Given /I am logged in as (.*)/ do |login|
  Factory(:anne)
  Factory(:madeline)
  Factory(:bob)
  visits "/login"  
  fills_in("login", :with => login.to_s)  
  fills_in("password", :with => "password")  
  clicks_button("Login")
end
