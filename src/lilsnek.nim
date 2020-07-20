import draw, strutils, sync, threadpool

proc getDimensionsFromUser(f: File): tuple[width, height: int] =
  stdout.write "Stage width: "
  result[0] = parseInt(readLine(f))
  stdout.write "Stage height: "
  result[1] = parseInt(readLine(f))

proc main() =
  let screen = getDimensionsFromUser(stdin)
  spawn runKBHandler()
  drawAnimation('#', screen[0], screen[1])

when isMainModule:
  main()
