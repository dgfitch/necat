Scenario: Unit board
  Given a board with radius 0
  Then the number of hexes should be 1

Scenario: First interesting board
  Given a board with radius 1
  Then the number of hexes should be 7

Scenario: Huge board
  Given a board with radius 4
  Then the number of hexes should be 61

