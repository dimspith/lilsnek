from illwill import illwillDeinit
import terminal

proc exitProc*() {.noconv.} =
  illwillDeinit()
  showCursor()
  quit(0)
