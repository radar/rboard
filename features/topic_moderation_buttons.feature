Feature: Moderation buttons
  In order to allow some users access to specific moderation features
  As an administrator
  I want to only show them some buttons

  Background:
    Given there is the usual setup
    Given I am logged in as "administrator" with the password "godly"

  Scenario: All buttons are visible
    And I am on the homepage
    When I follow "Public Forum"
    Then I should see the button to "Move"
    And I should see the button to "Lock"
    And I should see the button to "Unlock"
    And I should see the button to "Merge"
    And I should see the button to "Sticky"
    And I should see the button to "Unsticky"

  Scenario: Hiding lock / unlock buttons
    And I cannot lock topics
    And I am on the homepage
    When I follow "Public Forum"
    Then I should not see the button to "Lock"
    And I should not see the button to "Unlock"

  Scenario: Hiding sticky / unsticky buttons
    And I cannot sticky topics
    And I am on the homepage
    When I follow "Public Forum"
    Then I should not see the button to "Sticky"
    And I should not see the button to "Unsticky"

  Scenario: Hiding merge button
    And I cannot merge topics
    And I am on the homepage
    When I follow "Public Forum"
    Then I should not see the button to "Merge"

  Scenario: Hiding move button
    And I cannot move topics
    And I am on the homepage
    When I follow "Public Forum"
    Then I should not see the button to "Move"

