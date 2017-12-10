@chrome
Feature: A collection of different scenarios
  Scenario: A
    Given I navigate to Qatar portal
    And I search for a place to Buy in The Pearl:
    | field         | value  |
    | Property type | Villa  |
    | Min. bed      | 3 Beds |
    | Max. bed      | 7 Beds |
    And I am sorting the results by Price (high) instead of Featured
    Then I save search results into prices_list.csv

  Scenario: B
  Given I navigate to UAE portal
  And I click on Find agent tab
  And I filter the resulted agents
  | Languages |
  | Arabic    |
  | English   |
  | Hindi     |
  And I click on search button
  And I save original agents count
  And I filter agents from India from Nationality tab
  And I wait for 10 seconds
  When I save the new agents count
  Then I should notice that new agents number is less than original agents number

Scenario: C
  Given I navigate to UAE portal
  And I click on Find agent tab
  And I select the 1st agent
  And I save the following agent information:
  | field            |
  | Name             |
  | Nationality      |
  | Languages        |
  | License No.      |
  | About me         |
  | Phone number     |
  | Company name     |
  | Experience since |
  | Active listings  |
  | LinkedIn         |
  And I save a screenshot of current page with filename agent_page_in_english
  And I change the language to Arabic
  Then I save a screenshot of current page with filename agent_page_in_arabic







