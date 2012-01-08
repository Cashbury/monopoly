Feature: Money Program Enrollment
  As a Cashbury Operator
  I want to be able to enroll users into Money Programs
  From the administration area

  Scenario: Manually enroll a user
    Given I am an Operator
    And "user1@example.com" is a consumer
    And the following business exists:
      | Name |
      | Cadbury Bunnies |
    And "Cadbury Bunnies" has a Money program
    When I log into the site
    And I visit the user page for "user1@example.com"
    Then I should be able to enroll "user1@example.com" into the Money program for "Cadbury Bunnies"
    Then "user1@example.com" should be enrolled in the Money program for "Cadbury Bunnies"
    And "user1@example.com" should have a cash account with "Cadbury Bunnies"

