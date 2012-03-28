Feature: Undo
  Because I am human and make mistakes
  An admin
  Should be able to undo actions they make

  Scenario: delete a comment, then undo it
    Given I am logged in
    And the following post exists:
      | title    | body                                  |
      | My title | My test body                          |
    When I go to /admin
    And I follow "Posts"
    And I press "Delete Post"
    And I follow "Actions"
    And I press "Undo"
    Then a posts exists with attributes:
      | title    | body                                  |
      | My title | My test body                          |
