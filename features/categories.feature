Background:
  Given there is the usual setup

Scenario: Administrators should be able to create new categories
  Given I am logged in as "administrator"
  When I am on the homepage
  When I follow "Administration Section"
  And I follow "Categories"
  And I follow "New Category"
  And I fill in "Name" with "Test Category"
  And I fill in "Description" with "Testing!"
  And I press "Create"
  Then I should see "Category was created."
  And I should see "Test Category"
  
Scenario: Administrators should be able to create new categories
  Given I am logged in as "administrator"
  When I am on the homepage
  When I follow "Administration Section"
  And I follow "Categories"
  And I follow "edit_category_1"
  And I fill in "Name" with "Private Category"
  And I fill in "Description" with "Testing!"
  And I press "Update"
  Then I should see "Category was updated."
  And I should see "Private Category"
  
Scenario: Categories should be valid when updates
  Given I am logged in as "administrator"
  When I am on the homepage
  When I follow "Administration Section"
  And I follow "Categories"
  And I follow "edit_category_1"
  And I fill in "Name" with ""
  And I fill in "Description" with "Testing!"
  And I press "Update"
  Then I should see "The category was not updated."