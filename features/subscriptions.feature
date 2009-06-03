Feature: Managing Subscriptions
  In order to be notified of when topics are posted to
  Users
  Wish to have a central locations their subscribed topics
  
  Background:
    Given there is the usual setup
    
  Scenario: User who has posted to a topic should be subscribed to it
    Given I am logged in as "registered_user"
    And I am on the forums page
    When I follow "Public Forum"
    When I follow "New Topic"
    When I fill in "subject" with "Tribute"
    When I fill in "Text" with "This is just a tribute"
    When I press "Create"
    When I follow "Subscriptions"
    Then I should see "Tribute"
  
  