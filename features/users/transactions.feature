Feature: Viewing transactions as a user


  Scenario: I should be able to view my own transactions
    Given I am a Consumer
    When I log into the site
    And I visit my transactions page
    Then I should see all my recent transactions
