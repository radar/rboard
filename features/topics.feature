Feature: Topics

  Background:
    Given there is the usual setup


  Scenario: Registered users should be able to post new topics
    Given I am logged in as "registered_user"
    And I am on the forums page
    When I follow "Public Forum"
    When I follow "New Topic"
    When I fill in "subject" with "Tribute"
    When I fill in "Text" with "This is just a tribute"
    When I press "Create"
    Then I should see "rBoard -> Public Forum -> Tribute"
    
  Scenario: Registered users should not be able to posts new topics in closed forums
    Given I am logged in as "registered_user"
    And there is a closed forum
    And I am on the new topic page for "Closed Forum"
    Then I should see "This forum is closed, and you are unable to post here."
