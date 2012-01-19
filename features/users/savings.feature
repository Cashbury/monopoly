Feature: Savings for Users

  Scenario: Total aggregate savings for a user
    Given I am a Consumer with the auth token "hello"
    And I have saved "50" dollars by using cashburies at various businesses
    When I send a GET request to "/users/businesses/savings.xml" with the following:
      """
      auth_token=hello
      """
    Then show me the response
    Then the response status should be "200"
    Then show me the response
    #And the XML response should have "total-savings" with the text "50"

  Scenario: Savings for a user at a business
    Given I am a Consumer with the auth token "hello"
    Given the following business exists:
      | Name | ID |
      | Cadbury Bunnies | 7 |
    And I have saved "15" dollars by using cashburies at "Cadbury Bunnies"
    When I send a GET request to "/users/businesses/savings.xml" with the following:
      """
      auth_token=hello&id=7
      """
    Then show me the response
    Then the response status should be "200"
    Then show me the response
    #And the XML response should have "total-savings" with the text "50"