Feature: Forums
  In order to restrict people to the right forums
  Administrators
  want to ensure people are shown only the right forums
  
  Background: 
    Given I am logged in as "administrator"
    When I follow "Administration Section"
    Given there is the usual setup
  
Scenario: Administrators should be able to create new categories
  When I follow "Categories"
  When I follow "New Category"
  And I fill in "Name" with "Test Category"
  And I press "Create"
  Then I should see "Category was created."
  And I should see "Test Category"
  