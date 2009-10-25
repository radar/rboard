Feature: Forums
  In order to restrict people to the right forums
  Administrators
  want to ensure people are shown only the right forums
  
  Background:
    Given there is the usual setup
  
  Scenario: Viewing forums index as an anonymous user
    Given I am on the homepage
    Then I should see "Public Forum"

  Scenario: Viewing the public forum as an anonymous user
    Given I am on the homepage
    When I follow "Public Forum"
    Then I should see "Viewing forum: Public Forum"

  Scenario: Registered users should not be able to see hidden forums
    Given I am logged in as "registered_user"
    And there is an inactive forum
    Then I should not see "Hidden Forum"
    And I am on the forum page for "Hidden Forum"
    Then I should see "The forum you were looking for could not be found, or is inactive."

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
    
    