Feature: Edits
  In order to edit a post
  As a user
  I want that to be done

  Background:
    Given there is the usual setup

  Scenario: Editing a post
    Given I am logged in as "administrator" with the password "godly"
    And I am on the homepage
    When I follow "Public Forum"
    And I follow "Default topic"
    And I follow "Edit"
    And I fill in "Text" with "Something other than the norm."
    And I press "Update"
    Then I should see "This post was edited by administrator"
    When I follow "1 edit"


  Scenario: Editing a post silently
    Given I am logged in as "administrator" with the password "godly"
    And I am on the homepage
    When I follow "Public Forum"
    And I follow "Default topic"
    And I follow "Edit"
    And I fill in "Text" with "Something other than the norm."
    And I check "Edit silently"
    And I press "Update"
    Then I should see "This post was edited by administrator"
    When I follow "Logout"
    Given I am logged in as "registered_user"
    And I am on the homepage
    When I follow "Public Forum"
    And I follow "Default topic"
    Then I should not see "This post was edited by administrator"

