Before do
  Factory(:theme)
end

Feature: Manage users
  
  Scenario: Register new user
    Given I am on the new user page
    When I fill in "user_login" with "admin"
    And I fill in "user_email" with "admin@rboard.com"
    And I fill in "user_password" with "godly"
    And I fill in "user_password_confirmation" with "godly"
    And I press "Signup"
    Then I should see "Logged in as <a href=\"/users/1\">admin</a>"
  
  Scenario: Should not show the user list to anonymous users
    Given I am on the users page
    Then I should be redirected to "/forums"
    
    

