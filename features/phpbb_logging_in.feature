Feature: PHPBB Logging in
  In order to "integrate" well with PHPBB
  As a user
  I want to be able to log in
  
  Background:
    Given there is the usual setup
  
  Scenario: Logging in
    Given "phpbb_user"'s password is set to nil
    And I am logged in as "phpbb_user"
    # This of course means that they will now auth based on what's stored locally..
    Then "phpbb_user"'s password should now be set
    When I follow "Logout"
    Given I am logged in as "phpbb_user"
    
  
  
  

  
