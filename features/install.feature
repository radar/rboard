Feature: Installing Rboard
  In order to use rboard
  As a user
  I want the installation proceedure to go off without a hitch

  Scenario: Installation Epic
    Given I run the installer with the following details:
      | login    | email                   | password |
      | Radar    | radarlistener@gmail.com | password |

    # Initial forum, topic & post
    And I am on the homepage
    When I follow "Welcome to rBoard!"
    And I follow "Your first topic"
    Then I should see "Welcome to rBoard! Feel free to delete this post, topic and forum if you wish. Thank you for using rBoard."

    # Initial user login
    When I follow "Login"
    And I fill in "Login" with "Radar"
    And I fill in "Password" with "password"
    And I press "Login"
    Then I should see "Logged in successfully."

    # Posting a new topic
    When I follow "Welcome to rBoard!"
    When I follow "New Topic"
    And I fill in "Subject" with "This is a new topic!"
    And I fill in "Text" with "Hey, watch out!"
    And I press "Create"
    Then I should see "Topic was created."

    # Signing up as another user
    When I follow "Logout"
    When I follow "Signup"
    And I fill in "Login" with "Noob"
    And I fill in "Password" with "password"
    And I fill in "Confirm Password" with "password"
    And I fill in "Email" with "noob@noobland.com"
    And I press "Signup"
    Then I should see "Thanks for signing up!"

    # Posting a new topic as the new user
    When I follow "Welcome to rBoard!"
    When I follow "New Topic"
    And I fill in "Subject" with "This is another new topic!"
    And I fill in "Text" with "Hey, watch out!"
    And I press "Create"
    Then I should see "Topic was created."

    # Posting a reply as the new user
    When I follow "New Reply"
    And I fill in "Post" with "Hey, that's impressive!"
    And I press "Create"
    Then I should see "Post was created."



