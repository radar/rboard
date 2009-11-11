Feature: Category access permissions
  In order to duplicate the issue Nick Crowther reported on 11th November, 2009
  As a developer
  I want this feature to ensure it never happens again
  
  Scenario: Category permissions should be enforced
    Given there is Nick Crowther's setup
    And I am logged in as "Nick"
    And I am on the homepage
    Then I should see "Category One"
    And I should see "Forum One"
    And I should not see "Category Two"
    And I should not see "Forum Two"
    
    When I follow "Logout"
    
    Given I am logged in as "Ryan"
    And I am on the homepage
    Then I should see "Category Two"
    And I should see "Forum Two"
    And I should not see "Category One"
    And I should not see "Forum One"