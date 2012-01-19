Feature: Balance for a User

  Scenario: Balance at a business for a user
    Given I am a Consumer with the auth token "hello"
    Given the following business exists:
      | Name | ID |
      | Cadbury Bunnies | 7 |
    And "Cadbury Bunnies" is the current business
    And the current business has a Money program
    And I am enrolled in the money program at "Cadbury Bunnies"
    And I have "15" cashburies at "Cadbury Bunnies"
    And I have "20" dollars at "Cadbury Bunnies"
    When I send a GET request to "/users/businesses/balance.xml" with the following:
    """
    auth_token=hello&id=7
    """
    Then show me the response
    And the response status should be "200"
