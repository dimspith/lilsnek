import random
import game, keyboard
import illwill
import terminal
import utils

proc main() =
  # Start illwill in fullscreen mode and run the keyboard handler
  illwillInit(fullscreen=true)
  setControlCHook(exitProc)
  hideCursor()
  kbChan.open()
  runKBHandler()

  # Initialize the terminal buffer and draw all static elements
  gameobj.tb = newTerminalBuffer(terminalWidth(), terminalHeight())
  gameobj.drawStatic()

  # Initialize the randomizer
  randomize()

  # Redraw the screen continuously
  while true:
    redraw(gameobj)

when isMainModule:
  main()
