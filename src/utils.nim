from illwill import illwillDeinit
from terminal import showCursor

proc exitProc*() {.noconv.} =
  illwillDeinit()
  showCursor()
  quit(0)
