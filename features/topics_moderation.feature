Feature: Topics moderation
  In order to lock, delete, sticky and merge topics
  As a person who's able to do that
  I want the buttons to work for me
  
  Background:
    Given there is the usual setup
  
  Scenario: Locking selected topics
    Given I am logged in as "administrator" with the password "godly"
    And I am on the homepage
    When I follow "Public Forum"
    Then I should see 0 locked topics
    When I select "Default topic" for moderation
    And I press "Lock"
    Then I should see "All selected topics have been locked."
    Then I should see 1 locked topic