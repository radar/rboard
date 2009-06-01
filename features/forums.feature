Feature: Manage forums
  In order to restrict people to the right forums
  Administrators
  want to ensure people are shown only the right forums
  
  Scenario: Viewing forums index
    Given I am on the forums page
    Then I should see "Public Forum"

  Scenario: Viewing the public forum
    Given I am on the forums page
    When I follow "Public Forum"
    Then I should see "Viewing forum: Public Forum"
  
  Scenario: Registered users should be able to post new topics
    Given I am logged in as "registered_user"
    And I am on the forums page
    When I follow "Public Forum"
    When I follow "New Topic"
    When I fill in "subject" with "Tribute"
    When I fill in "Text" with "This is just a tribute"
    When I press "Create"
    Then I should see "rBoard -> Public Forum -> Tribute"
    