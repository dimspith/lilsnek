import algorithm
import random
import os
import illwill
import types, keyboard
from utils import exitProc

const initialSnake*: Snake =
  Snake(
  ## The initial snake consisting of 4 total cells in the middle of the screen
    body: @[
      SnakeBody(
        x: 29,
        y: 15,
      ),
      SnakeBody(
        x: 30,
        y: 15,
      ),
      SnakeBody(
        x: 31,
        y: 15,
      ),
      SnakeBody(
        x: 32,
        y: 15,
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

var gameobj*: Game = Game(
  ## The initial game's values
  tb: newTerminalBuffer(60, 30),
  tileBoard: makeNewTileBoard(),
  snake: initialSnake,
  food: (rand(0..59), rand(0..29)),
  score: 0,
  isPaused: false,
)

proc setSnakeDirection(game: Game): Game =
  ## Attempts to receive a keypress from the keyboard channel and set the
  ## snake's direction accordingly
  let move = kbChan.tryRecv()
  if move.dataAvailable:
    case move.msg:
      of LEFT:
        if game.snake.direction == RIGHT:
          discard
        else:
          game.snake.direction = LEFT
      of DOWN:
        if game.snake.direction == UP:
          discard
        else:
          game.snake.direction = DOWN
      of UP:
        if game.snake.direction == DOWN:
          discard
        else:
          game.snake.direction = UP
      of RIGHT:
        if game.snake.direction == LEFT:
          discard
        else:
          game.snake.direction = RIGHT
      else: discard
  game

proc moveAndDrawSnake(game: Game): Game =
  ## Fetches the snake's values, moves the snake by one in the direction it's heading
  ## and places it on the board
  var body = game.snake.body

  # Move all bodyparts except for the head
  for i in countdown(body.len-1, 1):
      body[i].x = body[i-1].x
      body[i].y = body[i-1].y

  # Move the snake's head in the correct direction
  case game.snake.direction:
    of LEFT:
      if body[0].x == 1:
        exitProc()
      dec(body[0].x)
    of DOWN:
      if body[0].y == 30:
        exitProc()
      inc(body[0].y)
    of UP:
      if body[0].y == 1:
        exitProc()
      dec(body[0].y)
    of RIGHT:
      if body[0].x == 60:
        exitProc()
      inc(body[0].x)
    of NONE:
      discard

  # If the snake ate food add one to it's body
  if game.tileBoard[body[0].x][body[0].y].cType == FOOD:
    body.add(
      SnakeBody(
        x: body[body.len - 1].x,
        y: body[body.len - 1].y
      )
    )
    game.food = (-1, -1)
      
  # Draw the snake's body
  for bodyPart in body[1..body.len-1]:
    game.tileBoard[bodyPart.x][bodyPart.y] = Cell(cType: BODY)

  # Draw the head
  game.tileBoard[body[0].x][body[0].y] = Cell(cType: HEAD)

  # Empty the last tile before we moved the snake
  game.tileBoard[body[body.len-1].x][body[body.len-1].y] = Cell(cType: EMPTY)

  game.snake.body = body
  game


proc createFood(game: var Game) =
  if game.food != (-1, -1):
    game.tileBoard[game.food[0]][game.food[1]] = Cell(cType: FOOD)
  else:
    game.food = (rand(1..59), rand(1..29))

iterator m2dpairs*[X,Y: static[int], T](a: array[X,array[Y,T]]): tuple[x: int, y: int, elem: T] {.inline.} =
  ## Iterator that traverses a 2d array and returns elements and indexes
  for i in countup(1, X-1):
    for j in countup(1, Y-1):
      yield (i, j, a[i][j])
    
func drawBoard(game: Game) =
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
      of FOOD:
        game.tb.setBackgroundColor(bgGreen)
        game.tb.write(x, y, " ")
        game.tb.resetAttributes()

proc drawInfo(game: Game) =
  discard

proc drawStatic*(game: Game) =
  ## Displays static elements i.e info, controls or decorations
  game.tb.write(1, 31, "Use hjkl to move around, p to pause and q to quit")
  game.tb.drawRect(0,0,60,30)
  # game.tb.drawHorizLine(1,59,28)

proc redraw*(game: var Game) =
  ## Redraws the screen, updating everything
  game.drawBoard()
  game.drawInfo()
  game.createFood()
  game = game.setSnakeDirection()
  game = game.moveAndDrawSnake()
  game.tb.display()
  sleep(120)

