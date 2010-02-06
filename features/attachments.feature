Feature: Attachments
  In order to be able to attach files to posts
  As a user
  I want that functionality

  Background:
    Given there is the usual setup

  Scenario: Attaching a single file to a post
    Given I am logged in as "registered_user"
    When I follow "Public Forum"
    And I follow "New Topic"
    When I fill in "Subject" with "Hey look! Attachments!"
    When I fill in "Text" with "Aren't they pretty?"
    And I attach the fixture file "photo.jpg" to "File"
    And I press "Create"
    Then I should see "Topic was created with one attachment."
