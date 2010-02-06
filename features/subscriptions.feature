Feature: Managing Subscriptions
  In order to be notified of when topics are posted to
  Users
  Wish to have a central locations their subscribed topics

  Background:
    Given there is the usual setup

  Scenario: User who has posted to a topic should be subscribed to it
    Given I am logged in as "registered_user"
    And I am on the homepage
    When I follow "Public Forum"
    When I follow "New Topic"
    When I fill in "subject" with "Tribute"
    When I fill in "Text" with "This is just a tribute"
    When I press "Create"
    When I follow "Subscriptions"
    Then I should see "Tribute"

  Scenario: User with subscriptions turned off should not be automatically subscribed to topics
    Given I am logged in as "registered_user"
    And I have auto subscriptions turned off
    And I am on the homepage
    When I follow "Public Forum"
    When I follow "New Topic"
    When I fill in "subject" with "Tribute"
    When I fill in "Text" with "This is just a tribute"
    When I press "Create"
    When I follow "Subscriptions"
    Then I should not see "Tribute"

  Scenario: User who has auto subscriptions turned off should be able to subscribe to them
    Given I am logged in as "registered_user"
    And I have auto subscriptions turned off
    When I follow "Public Forum"
    And I follow "Default topic"
    And I follow "Subscribe"
    Then I should see "You have subscribed to this topic."
    When I follow "Unsubscribe"
    Then I should see "You have unsubscribed from this topic."


