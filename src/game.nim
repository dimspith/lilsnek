import algorithm
import times
import os
import illwill
import sequtils, sugar

type
  Direction* = enum
    NONE, UP, DOWN, LEFT, RIGHT

  CellType = enum
    EMPTY,
    HEAD,
    BODY

  Cell = object
    case cType: CellType
    of EMPTY: discard
    of BODY: discard
    of HEAD: discard

  CellMatrix[W, H: static[int]] =
    array[1..W, array[1..H, Cell]]

  SnakeBody = object
    x: int
    y: int
    isHead: bool
    direction: Direction
    
  Snake* = seq[SnakeBody]

  Game* = ref object
    tb*: TerminalBuffer
    tileBoard*: CellMatrix[60, 30]
    snake*: Snake
    startTime*: DateTime
    endTime*: DateTime
    score*: int
    isPaused*: bool

var kbChan*: Channel[Direction]

func makeNewTileBoard(): CellMatrix[60,30] =
  ## Make a new empty tileboard with a snake in the middle
  # Initialize the tileboard
  var tbd: CellMatrix[60, 30]
  var emptyRow: array[0..29, Cell]
  emptyRow.fill(0, 29, Cell(cType: EMPTY))
  tbd.fill(0, 59, emptyRow)
  return tbd

const initialSnake*: Snake = @[
    SnakeBody(
      x: 29,
      y: 15,
      isHead: true,
      direction: LEFT
    ),
    SnakeBody(
      x: 30,
      y: 15,
      isHead: false,
      direction: LEFT
    ),
    SnakeBody(
      x: 31,
      y: 15,
      isHead: false,
      direction: LEFT
    )
  ]


proc newGame*(): Game =
  ## Creates a game object containing the initial values of a new game.
  result = Game(
    tb: newTerminalBuffer(60, 30),
    tileBoard: makeNewTileBoard(),
    startTime: now(),
    endTime: now(),
    score: 0,
    isPaused: false,
  )

proc moveSnake(game: Game) =
  let move = kbChan.tryRecv()
  if move.dataAvailable:
    case move.msg:
      of Direction.Left:
        echo "Left"
      of Direction.Down:
        echo "Down"
      of Direction.Up:
        echo "Up"
      of Direction.Right:
        echo "Right"
      else: discard

# proc nextFrame(game: Game) =
  # snake.map()

iterator m2dpairs[X,Y: static[int], T](a: array[X,array[Y,T]]): tuple[x: int, y: int, elem: T] {.inline.} =
  for i in countup(1, X-1):
    for j in countup(1, Y-1):
      yield (i, j, a[i][j])
    
proc drawBoard(game: Game) =
  ## Draws the game board and colors cells accordingly.
  for x, y, cell in m2dpairs(game.tileBoard):
    case cell.cType:
      of EMPTY:
        game.tb.setBackgroundColor(bgBlack)
        game.tb.write(x, y, " ")
        game.tb.resetAttributes()
      of BODY:
        game.tb.setBackgroundColor(bgYellow)
        game.tb.write(x, y, " ")
        game.tb.resetAttributes()
      of HEAD:
        game.tb.setBackgroundColor(bgRed)
        game.tb.write(x, y, " ")
        game.tb.resetAttributes()
            
proc drawInfo(game: Game) =
  game.tb.write(1, 31, "Use hjkl to move around, p to pause and q to quit")
  # game.tb.drawRect(0,0,60,30)
  # game.tb.drawHorizLine(1,59,28)

proc redraw*(game: Game) =
  ## Redraws the screen, moving the snake forward and updating the tiles.
  game.tb = newTerminalBuffer(terminalWidth(), terminalHeight())
  game.drawInfo()
  game.drawBoard()
  game.moveSnake()
  game.tb.display()
  sleep(500)

