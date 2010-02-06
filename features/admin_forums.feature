Feature: Forums
  In order to restrict people to the right forums
  Administrators
  want to ensure people are shown only the right forums

  Background:
    Given there is the usual setup
    Given I am logged in as "administrator" with the password "godly"
    And I am on the homepage
    When I follow "Administration Section"
    And I follow "Forums"

Scenario: Administrators should be able to create new forums
  And I follow "New Forum"
  And I fill in "Title" with "Test Forum"
  And I fill in "Description" with "Testing!"
  And I press "Create"
  Then I should see "Forum was created."
  And I should see "Test Forum"

Scenario: Administrators should be able to update forums
  And I follow "Edit"
  And I fill in "Title" with "Unmoderated"
  And I press "Update"
  Then I should see "The forum was updated."
  And I should see "Unmoderated"

Scenario: Moving a forum to the top
  And I follow "top"
  Then I should see "Forum has been moved to the top."

Scenario: Moving a forum to the bottom
  And I follow "bottom"
  Then I should see "Forum has been moved to the bottom."

Scenario: Moving a forum up
  And I follow "up"
  Then I should see "Forum has been moved higher."

Scenario: Moving a forum down
  And I follow "down"
  Then I should see "Forum has been moved lower."