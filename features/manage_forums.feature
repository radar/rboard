Before do
  Factory.create(:admin_forum)
  Factory.create(:moderator_forum)
  Factory.create(:anne)
  Factory.create(:madeline)
  Factory.create(:bob)
end

Feature: Manage forums

  Scenario: Viewing forums anonymously
    Given I am on the forums page
    Then I should not see "Admins Only"
    Then I should not see "Moderators Only"
    
  Scenario: Viewing forums as an admin
    Given I am on the forums page
    Given I am logged in as anne
    Then I should see "Admins Only"
    Then I should see "Moderators Only"
      
