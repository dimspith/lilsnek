import os, game, keyboard, utils
import illwill

var gameobj = newGame()

proc main() =
  # Start illwill in fullscreen mode and run the keyboard handler
  illwillInit(fullscreen=true)
  setControlCHook(exitProc)
  hideCursor()
  kbChan.open()
  runKBHandler()

  # Initialize the terminal buffer and draw everything that won't change later
  gameobj.tb = newTerminalBuffer(terminalWidth(), terminalHeight())
  gameobj.drawInfo()

  # Redraw
  while true:
    redraw(gameobj)

when isMainModule:
  main()
