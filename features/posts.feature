Feature: Posts
  In order to do things with posts
  As a user
  I want things to do

  Background:
    Given there is the usual setup
    And I am on the homepage

  Scenario: Viewing all posts for a user
    Given I am logged in as "registered_user"
    When I follow "administrator"
    When I follow "user_posts"
    Then I should see "Posts for administrator"

  Scenario: Starting a new post with a quote from another
    Given I am logged in as "registered_user"
    When I follow "Public Forum"
    And I follow "Default topic"
    And I follow "Quote"
    And I press "Create"
    Then I should see a quote by "administrator" that says "This is some default text"

  @wip
  Scenario: Editing a post
    Given I am logged in as "administrator" with the password "godly"
    When I follow "Public Forum"
    And I follow "Default topic"
    When I follow "Edit" within "post_1_actions"
    And I fill in "Text" with "This is some other text"