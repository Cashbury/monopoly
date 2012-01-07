@javascript
Feature: Money Program for Cashbury Operators
  As a Cashbury Operator
  I want to be able to administrate Money Programs
  From the administration area

  Scenario: Set up a money program
    Given I am an Operator
    And the following business exists:
      | Name |
      | Cadbury Bunnies |
    When I log into the site
    And I visit the program page for "Cadbury Bunnies"
    Then I should be able to make a new Money program
    And the business should have a cashbox account

  Scenario: Only one money program is allowed
    Given I am an Operator
    And the following business exists:
      | Name |
      | Cadbury Bunnies |
    When I log into the site
    And I visit the program page for "Cadbury Bunnies"
    And the current business has a Money program
    Then I should not be able to make a new Money program

  Scenario: Can not change a money program into a marketing program
    Given I am an Operator
    And the following business exists:
      | Name |
      | Cadbury Bunnies |
    When I log into the site
    And "Cadbury Bunnies" is the current business
    And the current business has a Money program
    Then I should not be able to change the Money program into a Marketing program

  Scenario: Set the max daily load and spend for a money program account
    Given I am an Operator
    And the following business exists:
      | Name |
      | Cadbury Bunnies |
    When I log into the site
    And "Cadbury Bunnies" is the current business
    And the current business has a Money program
    Then I should be able to set the cashbox account load limit to "15"
    And I should be able to set the cashbox account spend limit to "10"
