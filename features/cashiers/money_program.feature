Feature: Money Program for Cashiers
  As a Cashier
  I want to be able use Money Programs
  To load cash into a User's Cashbury Account
  To charge a User using Cashbury

  Scenario: Load a customer's account
    Given the following business exists:
      | Name |
      | Cadbury Bunnies |
    And I am a Cashier at "Cadbury Bunnies"
    And "Cadbury Bunnies" is the current business
    And the current business has a Money program
    And "bobjones@cal.edu" is a consumer
    And I send a POST request to "/users/cashiers/load_money.xml" with the following:
      """
      auth_token=hello&amount=55.0&customer_identifier=123456&long=35.505708&lat=33.803515 
      """
    Then show me the response
    Then the response status should be "200"
    And show me the response
