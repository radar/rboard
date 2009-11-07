Background:
  Given there is the usual setup
  Given I am logged in as "administrator" with the password "godly"
  When I am on the homepage
  When I follow "Administration Section"
  And I follow "Categories"

Scenario: Administrators should be able to create new categories
  And I follow "New Category"
  And I fill in "Name" with "Test Category"
  And I fill in "Description" with "Testing!"
  And I press "Create"
  Then I should see "Category was created."
  And I should see "Test Category"

Scenario: Administrators should be able to create new categories
  And I follow "Edit"
  And I fill in "Name" with "Private Category"
  And I fill in "Description" with "Testing!"
  And I press "Update"
  Then I should see "The category was updated."
  And I should see "Private Category"

Scenario: Categories should be valid when updates
  And I follow "Edit"
  And I fill in "Name" with ""
  And I fill in "Description" with "Testing!"
  And I press "Update"
  Then I should see "The category was not updated."