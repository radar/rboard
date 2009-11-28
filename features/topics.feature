Feature: Topics

  Background:
    Given there is the usual setup


  Scenario: Registered users should be able to post new topics
    Given I am logged in as "registered_user"
    When I follow "Public Forum"
    When I follow "New Topic"
    When I fill in "subject" with "Tribute"
    When I fill in "Text" with "This is just a tribute"
    When I press "Create"
    Then I should see "rBoard -> Public Category -> Public Forum -> Tribute"
    
  Scenario: Topics should not be able to be posted without subjects or text
    Given I am logged in as "registered_user"
    When I follow "Public Forum"
    When I follow "New Topic"
    And I press "Create"
    Then I should see "Text can't be blank"
    And I should see "Subject can't be blank"
    When I fill in "Subject" with "Alright then"
    And I press "Create"
    Then I should see "Text can't be blank"
    When I fill in "Text" with "Fine have it your way."
    And I press "Create"
    Then I should see "rBoard -> Public Category -> Public Forum -> Alright then"
  
  Scenario: Admins should be able to see topics in the admin forum
    Given I am logged in as "administrator" with the password "godly"
    When I follow "Admins Only"
    Then I should see "Default topic"
  
  Scenario: Admins should be able to edit topics
    Given I am logged in as "administrator" with the password "godly"
    When I follow "Admins Only"
    And I follow "Default Topic"
    When I follow "Edit topic"
    Then show me the page
    
  Scenario: Admins should be able to create a new topic in the admin forum
    Given I am logged in as "administrator" with the password "godly"
    When I follow "Admins Only"
    And I follow "New Topic"
    When I fill in "Subject" with "Look at me go!"
    And I fill in "Text" with "Wooooaaaaah!"
    And I press "Create"
    Then I should see "rBoard -> Admin Walled Garden -> Admins Only -> Look at me go!"