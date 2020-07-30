import algorithm
import times
import os
import illwill
# import sequtils, sugar

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
    
  Snake* = object
    body: seq[SnakeBody]
    direction: DIRECTION

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

const initialSnake*: Snake = Snake(
  body: @[
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
    ),
    SnakeBody(
      x: 32,
      y: 15,
      isHead: false,
      direction: LEFT
    )
  ],
  direction: LEFT
)


proc newGame*(): Game =
  ## Creates a game object containing the initial values of a new game.
  result = Game(
    tb: newTerminalBuffer(60, 30),
    tileBoard: makeNewTileBoard(),
    startTime: now(),
    endTime: now(),
    snake: initialSnake,
    score: 0,
    isPaused: false,
  )

proc moveSnake(game: Game): Game =
  let move = kbChan.tryRecv()
  if move.dataAvailable:
    case move.msg:
      of LEFT:  game.snake.direction = LEFT
      of DOWN:  game.snake.direction = DOWN
      of UP:    game.snake.direction = UP
      of RIGHT: game.snake.direction = RIGHT
      else: discard
  game

proc drawSnake(game: Game): Game =
  var body = game.snake.body

  for i in countdown(body.len-1, 0):
    if body[i].isHead:
      case game.snake.direction:
        of LEFT:  dec(body[i].x)
        of DOWN:  inc(body[i].y)
        of UP:    dec(body[i].y)
        of RIGHT: inc(body[i].x)
        of NONE: discard
    else:
      body[i].x = body[i-1].x
      body[i].y = body[i-1].y

  for bodyPart in body:
    if bodyPart.isHead:
      game.tileBoard[bodyPart.x][bodyPart.y] = Cell(cType: HEAD)
    else:
      game.tileBoard[bodyPart.x][bodyPart.y] = Cell(cType: BODY)

  game.tileBoard[body[body.len-1].x][body[body.len-1].y] = Cell(cType: EMPTY)

  game.snake.body = body
  game

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
            
proc drawInfo*(game: Game) =
  game.tb.write(1, 31, "Use hjkl to move around, p to pause and q to quit")
  # game.tb.drawRect(0,0,60,30)
  # game.tb.drawHorizLine(1,59,28)

proc redraw*(game: var Game) =
  ## Redraws the screen, moving the snake forward and updating the tiles.
  game.drawBoard()
  game = game.moveSnake()
  game = game.drawSnake()
  game.tb.display()
  sleep(180)

