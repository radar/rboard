Feature: Forums
  In order to restrict people to the right forums
  Administrators
  want to ensure people are shown only the right forums

  Background:
    Given there is the usual setup

  Scenario: Viewing forums index as an anonymous user
    Given I am on the homepage
    Then I should see "Public Forum"
    And I should see "Another Forum"

  Scenario: Viewing forums under a specific category
    Given I am on the homepage
    When I follow "Public Category"
    Then I should see "Public Forum"
    And I should not see "Another Forum"

  Scenario: Viewing the public forum as an anonymous user
    Given I am on the homepage
    When I follow "Public Forum"
    Then I should see "Viewing forum: Public Forum"

  Scenario: Only admins should see the admins only forum
    Given I am on the homepage
    Then I should not see "Admins Only"
    Given I am logged in as "registered_user"
    Then I should not see "Admins Only"
    When I follow "Logout"
    Given I am logged in as "administrator" with the password "godly"
    Then I should see "Admins Only"


  Scenario: Registered users should not be able to see hidden forums
    Given I am logged in as "registered_user"
    And there is an inactive forum
    Then I should not see "Hidden Forum"

  Scenario: Logged in as a user who can see inactive forums
    Given I am logged in as "registered_user"
    And there is an inactive forum
    And I can see inactive forums
    And I am on the homepage
    Then I should see "Hidden Forum"

  Scenario: Registered users should not be able to post in closed forums
    Given I am logged in as "registered_user"
    And there is a closed forum
    And I am on the homepage
    When I follow "Closed Forum"
    Then I should not see "New Topic"
    When I follow "Closed Forum's Topic"
    Then I should not see "New Reply"


