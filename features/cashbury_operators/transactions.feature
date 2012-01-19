Feature: Viewing transactions for businesses

  Scenario: Viewing transactions for a single business
    Given I am an Operator
    And the following business exists:
      | Name |
      | Cadbury Bunnies |
    When I log into the site
    Then I should be able to see all transactions for "Cadbury Bunnies"

  Scenario: Viewing transactions for all businesses
    Given I am an Operator
    And the following business exists:
      | Name |
      | Cadbury Bunnies |
    When I log into the site
    Then I should be able to see all transactions for all businesses
