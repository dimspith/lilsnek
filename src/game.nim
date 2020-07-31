import algorithm
import os
import illwill
import types, keyboard

const initialSnake*: Snake =
  Snake(
  ## The initial snake consisting of 4 total cells in the middle of the screen
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

func makeNewTileBoard*(): CellMatrix[60,30] =
  ## Make a new empty tileboard
  var tbd: CellMatrix[60, 30]
  var emptyRow: array[0..29, Cell]
  emptyRow.fill(0, 29, Cell(cType: EMPTY))
  tbd.fill(0, 59, emptyRow)
  return tbd

proc newGame*(): Game =
  ## Creates a game object containing the initial values of a new game.
  result = Game(
    tb: newTerminalBuffer(60, 30),
    tileBoard: makeNewTileBoard(),
    snake: initialSnake,
    score: 0,
    isPaused: false,
  )

proc setSnakeDirection(game: Game): Game =
  ## Attempts to receive a keypress from the keyboard channel and set the
  ## snake's direction accordingly
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
  ## Fetches the snake's values, moves the snake by one in the direction it's heading
  ## and places it on the board
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
  ## Displays static elements i.e info, controls or decorations
  game.tb.write(1, 31, "Use hjkl to move around, p to pause and q to quit")
  # game.tb.drawRect(0,0,60,30)
  # game.tb.drawHorizLine(1,59,28)

proc redraw*(game: var Game) =
  ## Redraws the screen, updating everything
  game.drawBoard()
  game = game.setSnakeDirection()
  game = game.drawSnake()
  game.tb.display()
  sleep(150)

