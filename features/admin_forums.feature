Feature: Forums
  In order to restrict people to the right forums
  Administrators
  want to ensure people are shown only the right forums

Scenario: Administrators should be able to create new forums
  Given I am logged in as "administrator" with the password "godly"
  And I am on the homepage
  When I follow "Administration Section"
  And I follow "Forums"
  And I follow "New Forum"
  And I fill in "Title" with "Test Forum"
  And I fill in "Description" with "Testing!"
  And I press "Create"
  Then I should see "Forum was created."
  And I should see "Test Forum"