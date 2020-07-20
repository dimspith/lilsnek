import threadpool, locks, os
import illwill

var
  thr: array[1, Thread[int]]
  L: Lock

proc exitProc() {.noconv.} =
  illwillDeinit()
  showCursor()
  quit(0)

proc getKeyInputs(n: int) {.thread.} =
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
          echo "Left"
        of Key.J:
          echo "Down"
        of Key.K:
          echo "Up"
        of Key.L:
          echo "Right"
        else: discard
    release(L)
    sleep 10


proc main() =
  illwillInit(fullscreen=true)
  setControlCHook(exitProc)
  hideCursor()
  createThread(thr[0], getKeyInputs, 0)

  while true:
    var tb = newTerminalBuffer(terminalWidth(), terminalHeight())
    tb.drawRect(0, 0, tb.width-1, tb.height-1)
    tb.display()
    sleep(20)


when isMainModule:
  main()
