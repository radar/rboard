Feature: Posts
  In order to do things with posts
  As a user
  I want things to do
  
  Background:
    Given there is the usual setup
    Given I am logged in as "registered_user"
    And I am on the homepage
  
  Scenario: Viewing all posts for a user
    When I follow "administrator"
    When I follow "user_posts"
    Then I should see "Posts for administrator"
    
  Scenario: Starting a new post with a quote from another
    When I follow "Public Forum"
    And I follow "Default topic"
    And I follow "Quote"
    And I press "Create"
    Then show me the page
    Then I should see a quote by "administrator" that says "This is some default text"
  