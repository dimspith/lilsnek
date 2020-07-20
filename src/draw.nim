import terminal, strutils, os, threadpool, sync

proc drawAnimation*(character: char, width, height: int) =
  # spawn runKBHandler()
  for i in countup(1, 20):
    setCursorPos(stdout, 0, 0)
    eraseScreen(stdout)
    echo(repeat(character, width))
    for i in countup(1, height-2):
      echo character, repeat(" ", width-2), character
    echo(repeat(character, width))
    echo i, "iterations."
    sleep(500)

    
