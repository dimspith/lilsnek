import times
import illwill

type
  Direction = enum
    NONE, UP, DOWN, LEFT, RIGHT
  BodyPart = object
    direction: Direction
  Cell = enum
    EMPTY,
    BODY = BodyPart(direction: NONE),
    FOOD
  CellMatrix[W, H: static[int]] =
    array[1..W, array[1..H, Cell]]
  Game* = ref object
    tb*: TerminalBuffer
    tileBoard*: CellMatrix[60, 30]
    startTime*: DateTime
    endTime*: DateTime
    score*: int
    isPaused*: bool
    snake*: seq[BodyPart]

let newBoard: CellMatrix[60, 30] =
  [[]]



proc newGame*(): Game =
  ## Creates a game object containing the initial values of a new game.
  result = Game(
    tb: newTerminalBuffer(60, 30),
    startTime: now(),
    endTime: now(),
    score: 0,
    isPaused: false,
  )

proc drawInfo*(game: Game) =
  game.tb.write(1, 29, "Use hjkl to move around, p to pause and q to quit")
  game.tb.drawRect(0,0,60,30)
  game.tb.drawHorizLine(0,60,28)

proc redraw*(game: Game) =
  ## Redraws the screen, moving the snake forward and updating the tiles.
  gameobj.tb = newTerminalBuffer(terminalWidth(), terminalHeight())
  gameobj.drawInfo()
  gameobj.tb.display()
  sleep(40)

