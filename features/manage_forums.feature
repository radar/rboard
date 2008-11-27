Feature: Manage forums
  
  Scenario: Viewing forums anonymously
    Given there are forums
    Given I am on the forums page
    Then I should not see "Admins Only"
    Then I should not see "Moderators Only"
    
  Scenario: Viewing forums as an admin
    Given there are forums
    Given I am logged in as anne
    Given I am on the forums page
    Then I should see "Admins Only"
    Then I should see "Moderators Only"
    
  Scenario: Viewing admin forum as an admin
    Given there are forums
    Given I am logged in as anne
    Given I am on the forum page for "Admins Only"
    Then I should not be redirected
      
  Scenario: Viewing admin forum as a moderator
    Given there are forums
    Given I am logged in as madeline
    Given I am on the forum page for "Admins Only"
    Then flash notice should be You are not allowed to see that forum.
    
  Scenario: Viewing moderator forum as a moderator
    Given there are forums
    Given I am logged in as madeline
    Given I am on the forum page for "Moderators Only"
    Then I should not be redirected
    
  Scenario: Viewing moderator forum as a user
    Given there are forums
    Given I am logged in as bob
    Given I am on the forum page for "Moderators Only"
    Then flash notice should be You are not allowed to see that forum.
  
  Scenario: Viewing user forum as a user
    Given there are forums
    Given I am logged in as bob
    Given I am on the forum page for "Users Only"
    Then I should not be redirected 
  