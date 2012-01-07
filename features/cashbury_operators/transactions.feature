Feature: Viewing transactions for businesses

  Scenario: Viewing transactions for a single business
    Given I am an Operator
    And the following business exists:
      | Name |
      | Cadbury Bunnies |
    When I log into the site
    And "Cadbury Bunnies" is the current business
