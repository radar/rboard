Feature: Topics

  Background:
    Given there is the usual setup


  Scenario: Registered users should be able to post new topics
    Given I am logged in as "registered_user"
    And I am on the homepage
    When I follow "Public Forum"
    And I follow "New Topic"
    And I fill in "Subject" with "Tribute"
    And I fill in "Text" with "This is just a tribute"
    And I press "Create"
    Then I should see "rBoard -> Public Category -> Public Forum -> Tribute"
    
  Scenario: Registered users should not be able to post new topics in closed forums
    Given I am logged in as "registered_user"
    And there is a closed forum
    And I am on the new topic page for "Closed Forum"
    Then I should see "This forum is closed, and you are unable to post here."
  
  Scenario: Administrators should be able to create and sticky a topic
    Given I am logged in as "administrator"
    And I am on the homepage
    When I follow "Public Forum"
    And I follow "New Topic"
    And I check "Sticky"
    And I fill in "Subject" with "Stuck!"
    And I fill in "Text" with "Stuck on you."
    And I press "Create"
    And I follow "Public Forum"
    Then column 1, row 1 in "topics" should contain "sticky"