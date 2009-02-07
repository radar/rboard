Feature: Manage forums
  In order to ensure intended functionality
  Users
  want to be able to do things with forums
  
  Scenario: Viewing forums
    Given there is a forum called 'Test'
    And I am on the forums index page
    Then I should see 'Test'