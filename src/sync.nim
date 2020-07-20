import terminal

var inputChan*: Channel[char]

proc runKBHandler*() =
  inputChan.open()
  var direction: char
  while true:
    direction = getch()
    case direction:
      of 'h': echo "l" #inputChan.send('l')
      of 'j': echo "d" #inputChan.send('d')
      of 'k': echo "u" #inputChan.send('u')
      of 'l': echo "r" #inputChan.send('r')
      else: continue
