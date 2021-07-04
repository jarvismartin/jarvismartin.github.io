include karax / prelude

type
  Square = tuple[row: int, col: int, black: bool, queen: bool, x: bool, group: int]
  Board = seq[Square]
  Pair = tuple[row: int, col: int]
  Solution = tuple[board: Board, valid: bool, queens: seq[int], openSquares: seq[int]]

var
  nValue: int = 0
  validSolutions: int = 0
  solutions: seq[Solution] = @[]
  potentials: seq[Solution] = @[]

proc buildBoard(): Board =
  var board: Board = @[]
  for row in 0 .. nValue - 1:
    var counter = 0
    for col in 0 .. nValue - 1:

      ## Make Checkerboard Pattern
      var blackVal = false
      if row mod 2 != 0 and col mod 2 == 0:
        blackVal = true
      elif row mod 2 == 0 and col mod 2 != 0:
        blackVal = true
      else:
        blackVal = false

      let newTuple: Square = (row: row + 1, col: col + 1, black: blackVal, queen: false, x: false, group: 0)
      ## echo newTuple

      board.add(newTuple)
      counter += 1

  return board

proc checkDiagonal(s: Square, qLoc: Pair): bool =
  for i in 0 .. nValue:
    if s.row == qLoc.row + i:
      if s.col == qLoc.col + i:
        return true

    if s.row == qLoc.row - i:
      if s.col == qLoc.col - i:
        return true

    if s.row == qLoc.row + i:
      if s.col == qLoc.col - i:
        return true

    if s.row == qLoc.row - i:
      if s.col == qLoc.col + i:
        return true

  return false

## Show which spaces cannot contain a queen
proc cannotBeQueen(s: Square, qLoc: Pair): bool =
  if s.row == qLoc.row:
    ## Horizontal
    return true
  elif s.col == qLoc.col:
    ## Vertical
    return true
  elif checkDiagonal(s, qLoc):
    ## Diagonal
    return true
  else:
    return false

## Add a queen to a board
proc addQueen(board: Board, asi: int, group: int): tuple[ board: Board, availableSquares: seq[int]] =

  var newBoard = board
  var avSq: seq[int] = @[]

  ## Put a queen in the first available square.
  newBoard[asi].queen = true
  newBoard[asi].x = true
  newBoard[asi].group = group

  ## X squares this queen can attack on board
  for si, square in newBoard:
    ## Don't check if we already know it can't be a queen
    if square.x == false:
      newBoard[si].x = cannotBeQueen(square, (row: newBoard[asi].row, col: newBoard[asi].col))
      newBoard[si].group = group

      if not newBoard[si].x:
        avSq.add(si)

  ## Return updated board and available squares
  return (board: newBoard, availableSquares: avSq)

proc findSolutions(n: int) =
  echo "find solutions when n is ", nValue

  ## Clear old solutions
  solutions = @[]
  validSolutions = 0

  var board = buildBoard()
  ## echo "BOARD: ", $board

  ## Add a queen to each square in row 1
  for i in 0 .. nValue - 1:

    ## Copy board and find solutions
    ## for THIS board
    var b = board

    ## Add row 1 queen
    b[i].queen = true
    b[i].x = true
    b[i].group = 1

    var queens = @[i]

    ## echo "INITIAL QUEEN IN SQUARE: ", i

    var availableSquares: seq[int] = @[]

    ## x every square this queen can attack
    for si, square in b:
      ## Don't check if we already know it can't be a queen
      ## if square.x == false:
      b[si].x = cannotBeQueen(square, (row: b[i].row, col: b[i].col))
      b[si].group = 1

      if not b[si].x:
        availableSquares.add(si)

    ## echo "AVAILABLE SQUARES: ", $availableSquares

    var validity = false
    if nValue == 1:
      validity = true

    ## Add this to this list of potential solutions
    let newSoln = (board: b, valid: validity, queens: queens, openSquares: availableSquares)
    potentials.add(newSoln)

    for i, s in potentials:

      for i in 0 .. nValue - 1:
        echo "BEFORE WHILE i: ", i

        ## Use counter to iterate over
        ## All available squares
        var counter = 0

        var newSolution = s
        newSolution.openSquares = newSolution.openSquares[i .. newSolution.openSquares.len - 1]

        while counter <= s.openSquares.len:

          echo "\tqueens: ", newSolution.queens
          echo "\topenSquares: ", newSolution.openSquares

          echo "\tADD QUEEN to ", newSolution.openSquares[0]
          var update = addQueen(newSolution.board, newSolution.openSquares[0], newSolution.queens.len + 1)
          ## echo "\tUPDATE:\n", update

          ## Update board
          newSolution.board = update.board
          ## Update queens
          newSolution.queens.add(newSolution.openSquares[0])
          ## Update openSquares
          newSolution.openSquares = update.availableSquares

          if newSolution.openSquares.len == 0:

            if newSolution.queens.len == nValue:
              newSolution.valid = true
              validSolutions += 1

            ## Update solutions
            echo "ADDING SOLUTION"
            solutions.add(newSolution)

            counter += 1

            ## Go to the next available square
            ## newSolution = s


            echo "BREAK"
            break


          ## newSolution.board = update.board
          ## newSolution.queens.add(s.openSquares[0])
          ## echo "NEW SOLUTION:\n", newSolution

          ## if update.openSquares.len == 0:
          ## if update.availableSquares.len == 0:
          ##   echo "NO MORE SQUARES AVAILABLE"
          ##   break



#[
    for avSqIndex, n in availableSquares:
      ## Capture current board
      var thisBoard = b
      ## echo "THIS BOARD: ", thisBoard

      ## Hold the currently available squares for this board
      var avSq = availableSquares

      ## Count the number of queens on this board
      var queens = 1
      ## Track this board's validity as a solution
      var validity = false

      echo "\tADD QUEEN TO SQUARE ", avSq[avSqIndex]
      var queen2AS = addQueen(thisBoard, avSq[avSqIndex], queens + 1)
      ## echo "\tADDED QUEEN: ", queen2AS

      ## Update this board
      thisBoard = queen2AS.board

      ## Update avSq
      avSq = queen2AS.availableSquares



      ## WHILE LOOP
      var keepGoing = true
      var counter = 0

      ## Capture squares available in this while loop
      var av = avSq

      while keepGoing and counter < 10:

        echo "\t\tWHILE available squares: ", av

        echo "\t\tADD QUEEN TO SQUARE ", av[0]
        var addedQueen = addQueen(thisBoard, av[0], queens + 1)
        ## echo "ADDED QUEEN: ", addedQueen

        if addedQueen.availableSquares.len == 0:
          keepGoing = false
          av = avSq
          echo "\t\tSTOP!!!"

        queens += 1
        if queens == nValue:
          validity = true
          echo "\t\tVALID SOLUTION"

        ## Update this board
        thisBoard = addedQueen.board

        ## Update available squares
        av = addedQueen.availableSquares

        counter += 1

      ## FOR NOW -- see what it looks like
      echo "ADDING SOLUTION"
      let newSoln = (board: thisBoard, valid: validity)
      solutions.add(newSoln)
      ## echo "solutions: ", $solutions
]#


## Function to handle adding a board square to the DOM
## Uses solutions->board->square data to determine presentation
proc squareDiv(s: Square): VNode =
  ## echo "squareDiv s: ", s
  var class = "square"
  if s.black:
    class.add(" black")
  if s.x:
    class.add(" x")

  class.add(" group-" & $s.group)

  result = buildHtml(tdiv):
    if s.queen:
      tdiv(class=class):
        ## img(src="./img/queen.png")
        italic(class="fas fa-chess-queen")
    else:
      if s.x:
        tdiv(class=class):
          ## img(src="./img/x.svg")
          italic(class="fas fa-times")
      else:
        tdiv(class=class)

proc createDom(): VNode =
  result = buildHtml(tdiv):
    section(class="section"):
      tdiv(class="container"):
        h1(class="title"):
          text"Welcome to a Work in Progress"
        p():
          text"The n-queens puzzle is the problem of placing n queens on an n x n chessboard such that no two queens attack each other."
        p():
          text"Given an integer n, such that 1 <= n <= 9, return all distinct solutions to the n-queens puzzle. You may return the answer in any order. Each solution contains a distinct board configuration of the n-queens' placement."

        section(class="section"):
          tdiv(class="level"):
            tdiv(class="level-left"):
              tdiv(class="level-item"):
                tdiv():text"Please choose a value for n:"
              tdiv(class="level-item"):
                tdiv(class="select"):
                  select():
                    proc onclick (ev: Event; n: VNode) =
                      ## echo n.value
                      nValue = n.value.parseInt()
                      findSolutions(nValue)
                    option():text"Choose One"
                    for n in 1 .. 9:
                      option():text $n

            tdiv(class="level-right is-size-3"):
              if nValue > 0:
                h3(class="level-item"):
                  span():text $validSolutions
                h5(class="level-item"):
                  span():text"Valid in"
                h5(class="level-item"):
                  span():text $solutions.len
                h5(class="level-item"):
                  span():text"Possible Solution"
                  if validSolutions != 1:
                    span():text"s"


        section(class="section boards"):
            if nValue > 0:
              for s in solutions:
                tdiv(class="board"):
                  for r in 1 .. nValue:
                    ## echo "r: ", r
                    tdiv(class="flex"):

                      for i in (r * nValue) - nValue .. (r * nValue - 1):
                        ## echo "i: ", i
                        ## Use a proc to return this square
                        squareDiv(s.board[i])

                  tdiv(class="valid"):
                    if s.valid:
                      italic(class="fas fa-check has-text-success")
                    else:
                      italic(class="fas fa-times has-text-danger")

            else:
              tdiv():text""

setRenderer createDom
