Feature: Groups Administration
  In order to manage groups
  As an admin
  I want that to be simple

  Background:
    Given there is the usual setup
    When I am logged in as "administrator" with the password "godly"
    And I follow "Administration Section"
    And I follow "Groups"

  @wip
  Scenario: Creating a new group
    When I follow "New"
    And I fill in "Name" with "Viewers"
    And I check "Can see category?"
    And I check "Can see forum?"
    And I press "Create"
    And I follow "members_for_viewers"



