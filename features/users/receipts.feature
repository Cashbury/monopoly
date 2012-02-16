Feature: Receipts for User

  Scenario: Total receipts for a user
    Given the following business exists:
      | Name |
      | Cadbury Bunnies |
    And I am a Cashier at "Cadbury Bunnies"
    And "Cadbury Bunnies" is the current business
    And the current business has a Money program
    And "bobjones@cal.edu" is the current consumer and has an auth token "goodbye"
    And I send a POST request to "/users/cashiers/load_money.xml" with the following:
      """
      auth_token=hello&amount=55.0&customer_identifier=123456&long=35.505708&lat=33.803515 
      """
    Then show me the response
    Then the response status should be "200"
    And show me the response
    When I send a GET request to "/users/receipts/receipts-customer.xml" with the following:
      """
      auth_token=goodbye
      """
    Then show me the response
    Then the response status should be "200"

