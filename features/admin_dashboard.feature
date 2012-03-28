Feature: Dashboard
  Because I want to see what the go is with my blog
  An admin
  Should be able to see interesting things on the dashboard

  Scenario: viewing latest posts in dash board
    Given I am logged in
    And a some post exists
    When I go to /admin
    Then I should see "Latest Posts"
