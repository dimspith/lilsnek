import os, game, keyboard, utils
import illwill

var gameobj = newGame()

proc main() =
  illwillInit(fullscreen=true)
  setControlCHook(exitProc)
  hideCursor()
  kbChan.open()
  runKBHandler()
  while true:
    redraw(gameobj)

when isMainModule:
  main()
