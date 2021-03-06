from locks    import Lock, acquire, release
from os       import sleep
from illwill  import getKey, Key, write, illwillDeinit
import types
import utils

var
  thr: array[1, Thread[void]]
  L: Lock
  kbChan*: Channel[Direction]

proc getKeyInputs() {.thread.} =
  ## Continuously get keypresses and send directions through the channel `kbChan`
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
        of Key.H, Key.A:
          kbChan.send(LEFT)
        of Key.J, Key.S:
          kbChan.send(DOWN)
        of Key.K, Key.W:
          kbChan.send(UP)
        of Key.L, Key.D:
          kbChan.send(RIGHT)
        else: discard
    release(L)
    sleep 10

proc runKBHandler*() =
    createThread(thr[0], getKeyInputs)
