Feature: Posts

  Background:
    Given there is the usual setup
    
  Scenario: Registered users should not be able to post new topics in closed forums
    Given I am logged in as "registered_user"
    And there is a closed forum
    And I am on the reply page for the first topic in "Closed Forum"
    Then I should see "This forum is closed, and you are unable to post here."
