Feature: Managing groups
  
  Background:
    Given there is the usual setup
  
  Scenario: Managing users
    Given I am logged in as "administrator"
    Then I should see "administrator"
    Given I am on the administrator's group page
    Then I should see "Administrators"
    When I follow "members_for_registered_users"
    Then I should see "registered_user"
    