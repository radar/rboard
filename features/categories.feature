Feature: Categories

  Background:
    Given there is the usual setup

  Scenario: Admins only should be able to view the admin only category
    Given I am on the homepage
    Then I should not see "Admin Walled Garden"
    Given I am logged in as "registered_user"
    Then I should not see "Admin Walled Garden"
    When I follow "Logout"
    Given I am logged in as "administrator" with the password "godly"
    Then I should see "Admin Walled Garden"

