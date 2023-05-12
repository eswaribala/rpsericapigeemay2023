@token
Feature:
  As a Client App 
  I want to access the protected resource of an API
  So that I can retrieve different types of information

  Scenario: User Authorizes
    Given I navigate to the authorize page
    When I sign in and consent
    Then I am redirected to the Client App
    And I receive an auth code in a query param
    And I store the auth code in global scope
    And I store the state parameter in global scope

  Scenario: Generate Access Token
    Given I set form parameters to 
      | parameter   | value		      |
      | grant_type  | authorization_code      |
      | code        | `authCode`              |
      | redirect_uri| https://httpbin.org/get |
      | client_id     | `clientId`              |
      | client_secret | `clientSecret`          |
    When I POST to /token
    Then response code should be 200
    And I store the value of body path $.access_token as userToken in global scope

  Scenario: I should get an error if client_id is invalid
    Given I set form parameters to 
      | parameter   | value		      |
      | grant_type  | authorization_code      |
      | code        | `authCode`              |
      | redirect_uri| https://httpbin.org/get |
      | client_id     | invalid-client          |
      | client_secret | `clientSecret`          |
    When I POST to /token
    Then response code should be 401
    And response body should be valid json

  Scenario: I should get an error if client_secret is invalid
    Given I set form parameters to 
      | parameter   | value		      |
      | grant_type  | authorization_code      |
      | code        | `authCode`              |
      | redirect_uri| https://httpbin.org/get |
      | client_id     | `clientId`              |
      | client_secret | invalid-client          |
    When I POST to /token
    Then response code should be 401
    And response body path $.error should be invalid_client

  Scenario: I should get an error if redirect_uri is missing or invalid
    Given I set form parameters to 
      | parameter   | value		      |
      | grant_type  | authorization_code      |
      | code        | `authCode`              |
      | redirect_uri| https://example.com/invalid |
      | client_id     | `clientId`              |
      | client_secret | `clientSecret`          |
    When I POST to /token
    Then response code should be 400
    And response body path $.error should be invalid_request
  
  Scenario: I should get an error if authorization code is invalid
    Given I set form parameters to 
      | parameter   | value		      |
      | grant_type  | authorization_code      |
      | code        | invalid-code            |
      | redirect_uri| https://httpbin.org/get |
      | client_id     | `clientId`              |
      | client_secret | `clientSecret`          |
    When I POST to /token
    Then response code should be 404
    And response body should be valid json

  Scenario: I should get an error if authorization code is missing
    Given I set form parameters to 
      | parameter   | value		      |
      | grant_type  | authorization_code      |
      | redirect_uri| https://httpbin.org/get |
      | client_id     | `clientId`              |
      | client_secret | `clientSecret`          |
    When I POST to /token
    Then response code should be 400
    And response body path $.error should be invalid_grant

  Scenario: I should get an error if grant_type is not authorization_code
    Given I set form parameters to 
      | parameter   | value		      |
      | grant_type  | xxx           |
      | code        | `authCode`              |
      | redirect_uri| https://httpbin.org/get |
      | client_id     | `clientId`              |
      | client_secret | `clientSecret`          |
    When I POST to /token
    Then response code should be 400
    And response body path $.error should be unsupported_grant_type

