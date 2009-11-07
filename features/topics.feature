Feature: Topics

  Background:
    Given there is the usual setup


  Scenario: Registered users should be able to post new topics
    Given I am logged in as "registered_user"
    And I am on the homepage
    When I follow "Public Forum"
    When I follow "New Topic"
    When I fill in "subject" with "Tribute"
    When I fill in "Text" with "This is just a tribute"
    When I press "Create"
    Then I should see "rBoard -> Public Category -> Public Forum -> Tribute"