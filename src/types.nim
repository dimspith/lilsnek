from illwill import TerminalBuffer

type
  Direction* = enum
    NONE, UP, DOWN, LEFT, RIGHT

  CellType* = enum
    EMPTY,
    HEAD,
    BODY,
    FOOD

  Cell* = object
    case cType*: CellType
    of EMPTY: discard
    of BODY: discard
    of HEAD: discard
    of FOOD: discard

  CellMatrix*[W, H: static[int]] =
    array[1..W, array[1..H, Cell]]

  SnakeBody* = object
    x*: int
    y*: int
    
  Snake* = object
    body*: seq[SnakeBody]
    direction*: Direction

  Game* = ref object
    tb*: TerminalBuffer
    tileBoard*: CellMatrix[60, 30]
    snake*: Snake
    score*: int
    isPaused*: bool
