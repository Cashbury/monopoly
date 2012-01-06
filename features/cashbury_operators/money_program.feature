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
