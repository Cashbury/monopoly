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
    And "bobjones@cal.edu" is the current consumer
    And Show me the current consumer identifier code
    And I send a POST request to "/users/cashiers/load_money.xml" with the following:
      """
      auth_token=hello&amount=55.0&customer_identifier=123456&long=35.505708&lat=33.803515 
      """
    Then show me the response
    Then the response status should be "200"
    And show me the response

  Scenario: Charge a customer's account
    Given the following business exists:
      | Name |
      | Cadbury Bunnies |
    And I am a Cashier at "Cadbury Bunnies"
    And "Cadbury Bunnies" is the current business
    And the current business has a Money program
    And "bobjones@cal.edu" is the current consumer
    And the current consumer has a cash account at the current business with a balance of 200
    And I send a POST request to "/users/cashiers/charge_customer.xml" with the following:
      """
      auth_token=hello&amount=55.0&tip=5.0&customer_identifier=123456&long=35.505708&lat=33.803515 
      """
    Then show me the response
    Then the response status should be "200"
    And show me the response
    
