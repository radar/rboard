Feature: Attachments
  In order to attach files to posts
  As a user
  I want a simple interface
  
  Background:
    Given there is the usual setup
    Given I am logged in as "registered_user"
  
  Scenario: Attaching files to a new post
    Given I am on the homepage
    When I follow "Public Forum"
    And I follow "New Topic"
    And I fill in "Subject" with "Look Ma, Attachments!"
    And I fill in "Text" with "Woah! Look at those attachments!"
    And I check "I have attachments"
    When I press "Create"
    Then I should see "Attachments"
    Then show me the page
    When I attach the file at "../spec/fixtures/fugu.png" to "file"
    And I press "Attach"
    Then I should see "1 Attachment"
    And I should see "fugu.png"
    When I press "Post"
    Then I should see "Look Ma, Attachments!"