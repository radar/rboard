Feature: Managing groups

  Background:
    Given there is the usual setup

  Scenario: Managing users
    Given I am logged in as "administrator" with the password "godly"
    Then I should see "administrator"
    Given I am on the homepage
    When I follow "Administration Section"
    And I follow "Groups"
    Then I should see "Administrators"
    When I follow "members_for_registered_users"
    Then I should see "registered_user"

