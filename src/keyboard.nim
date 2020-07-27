import locks, os, utils, game
from illwill import getKey, Key, write

var
  thr: array[1, Thread[void]]
  L: Lock

proc getKeyInputs() {.thread.} =
  while true:
    acquire(L)
    {.gcSafe.}:
      var key = getKey()
      case key:
        of Key.None:
          discard
        of Key.Q:
          release(L)
          exitProc()
        of Key.H:
          kbChan.send(LEFT)
        of Key.J:
          kbChan.send(DOWN)
        of Key.K:
          kbChan.send(UP)
        of Key.L:
          kbChan.send(RIGHT)
        else: discard
    release(L)
    sleep 10

proc runKBHandler*() =
    createThread(thr[0], getKeyInputs)
