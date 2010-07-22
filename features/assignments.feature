Feature: Manage assignments
  In order to make sure assignments accepted for and event is consistent with people assigned to that event
  I want assignments accepted is automatically updated when assignmente state changes

  Scenario: Ask for an assignment
    Given a user
    And an event for which this user has not applied for
    When the user applies for it
    Then he should have a new assignment for that event
    And assignment state should be pendant
    And assignments accepted for that event should be consistent

  Scenario: Accept an assignment
    Given a user
    And an event for which this user has already applied for
    When the assignment is accepted
    Then the assignment shoud be accepted
    And assignments accepted for that event should be consistent

  Scenario: Cancel a non-accepted assignment
    Given a user
    And an event for which this user has already applied for
    And this assignment is pendant
    When the assignment is canceled
    Then the assignment should be canceled
    And assignments accepted for that event should be consistent

  Scenario: Cancel an accepted assignment
    Given a user
    And an event for which this user has already applied for
    And this assignment is accepted
    When the assignment is canceled
    Then the assignment should be canceled
    And assignments accepted for that event should be consistent

