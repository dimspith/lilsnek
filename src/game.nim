import illwill

type Direction = enum
  UP, DOWN, LEFT, RIGHT

type BodyPart = object
    x: int,
    y: int,
    direction: Direction

type Snake = object
    body: seq[BodyPart]

type Game* = object
    tileBoard: seq[seq[int]],
    startTime: DateTime,
    endTime: DateTime,
    score: int,
    isPaused: bool,
    snake: int

