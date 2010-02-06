Feature: Topics moderation
  In order to lock, delete, sticky and merge topics
  As a person who's able to do that
  I want the buttons to work for me

  Background:
    Given there is the usual setup
    Given I am logged in as "administrator" with the password "godly"
    And I am on the homepage
    When I follow "Public Forum"

    # This topic is used for the moving + merging scenarios only.
    When I follow "New Topic"
    And I fill in "Subject" with "Posted in the wrong forum"
    And I fill in "Text" with "Complete noob mistake"
    And I press "Create"
    Then I should see "Topic was created"
    When I follow "Public Forum"

  Scenario: Locking / Unlocking selected topics
    Then I should see 0 locked topics
    When I select "Default topic" for moderation
    And I press "Lock"
    Then I should see "All selected topics have been locked."
    Then I should see 1 locked topic
    When I select "Default topic" for moderation
    And I press "Unlock"
    Then I should see "All selected topics have been unlocked."
    Then I should see 0 locked topics

  Scenario: Stickying / Unstickying a selected topic
    Then I should see 0 sticky topics
    When I select "Default topic" for moderation
    And I press "Sticky"
    Then I should see "All selected topics have been stickied."
    Then I should see 1 sticky topic
    When I select "Default topic" for moderation
    And I press "Unsticky"
    Then I should see "All selected topics have been unstickied."
    Then I should see 0 sticky topics

  Scenario: Moving a topic without a redirect
    And I select "Posted in the wrong forum" for moderation
    And I select "Sub of Public Forum" from "new_forum_id"
    And I press "Move"
    Then I should see "All selected topics have been moved."
    Then I should not see "Posted in the wrong forum"
    When I follow "Sub of Public Forum"
    Then I should see "Posted in the wrong forum"

  Scenario: Moving a topic with a redirect
    And I select "Posted in the wrong forum" for moderation
    And I select "Sub of Public Forum" from "new_forum_id"
    When I check "Leave redirect"
    And I press "Move"
    Then I should see "All selected topics have been moved."
    Then I should see "Posted in the wrong forum"
    When I follow "Posted in the wrong forum"
    Then I should see "Posted in the wrong forum"
    And I should be in the "Sub of Public Forum" forum

  Scenario: Merging two topics
    # We use another topic here because there's a number of "Default topic"
    # We want something with a unique subject!
    When I follow "New Topic"
    And I fill in "Subject" with "Going to be merged"
    And I fill in "Text" with "Merge ahoy!"
    And I press "Create"
    Then I should see "Topic was created."
    When I follow "Public Forum"
    When I select "Posted in the wrong forum" for moderation
    And I select "Going to be merged" for moderation
    When I press "Merge"

    # Regressional testing
    Then I should not see "The topics you were looking for could not be found."

    When I choose "Posted in the wrong forum"
    And I press "Merge"
    Then I should see "Posted in the wrong forum"


