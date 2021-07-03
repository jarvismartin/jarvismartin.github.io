include karax / prelude

type
  Square = tuple[row: int, col: int, black: bool, queen: bool, x: bool, group: int]
  Board = seq[Square]
  Pair = tuple[row: int, col: int]
  Solution = tuple[board: Board, valid: bool]

var
  nValue: int = 0
  validSolutions: int = 0
  solutions: seq[Solution] = @[]

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

  ## for n in 1 .. nValue:
  ##   ## Build a board
  ##   var board = buildBoard();

  ##   ## Assign a queen to one of the top row spaces
  ##   board[n - 1].queen = true

  ##   ## Handle n is 1
  ##   var validity = false
  ##   if nValue == 1:
  ##     validity = true
  ##     validSolutions += 1

  ##   ## Add board to solutions
  ##   let newSoln = (board: board, valid: validity)

  ##   solutions.add(newSoln)
  ##   ## echo "solutions: ", $solutions

  ## ## Go through each possible solution
  ## for index, solution in solutions:
  ##   var board = solutions[index].board
  ##   #[
  ##     Keep adding queens
  ##     until solution is verified
  ##     (n queens on board or fail)
  ##   ]#
  ##   var
  ##     tries = 0
  ##     queens = 1

  ##   while tries <= board.len - 1:
  ##     echo "while tries ", tries
  ##     echo "queens: ", queens

  ##     var
  ##       queenAdded = (row: 0, col: 0)
  ##       qLoc = (row: 0, col: 0)

  ##     ## Get (or set) current queen location
  ##     for sqI, sq in solutions[index].board:
  ##       if sq.queen == true:
  ##         qLoc = (row: sq.row, col: sq.col)

  ##     ## Generate diagonals
  ##     var diagonals = getDiagonals(board, qLoc)

  ##     for si, square in solutions[index].board:
  ##       ## Don't check if we already know it can't be a queen
  ##       if square.x == false:
  ##         solutions[index].board[si].x = cannotBeQueen(si + 1, square, qLoc, diagonals)
  ##         solutions[index].board[si].group = queens

  ##     ## Try to add another queen
  ##     queenAdded = addQueen(index, queens + 1)
  ##     if queenAdded.row == 0:
  ##       break

  ##     if queenAdded.row != 0:
  ##       queens += 1
  ##       qLoc = queenAdded

  ##       if queens == nValue:
  ##         solutions[index].valid = true
  ##         validSolutions += 1

  ##     ## Avoid infinite loop
  ##     tries += 1

  var board = buildBoard()
  ## echo "BOARD: ", $board

  #[
  ## var
  ##   currentRow = 1
  ##   currentCol = 1

  ## Try adding a queen in each square
  for i in 0 .. board.len - 1:

    ## Copy board and find solutions
    ## for THIS board
    var b = board

    var
      queens = 1
      ## currentRow = 1
      qLoc = (row: b[i].row, col: b[i].col)
      validity = false

    ## if i > (nValue * currentRow):
    ##   currentRow += 1
    ## echo "currentRow: ", currentRow

    ## Add initial queen
    if b[i].row == 1:
      b[i].queen = true
      b[i].x = true
      b[i].group = 1
    elif b[i].row != nValue and b[i].col != 1 and b[i].col != nValue:
      b[i].queen = true
      b[i].x = true
      b[i].group = 1
    else:
      continue

    ## Keep adding queens until solution is validated
    var keepGoing = true
    var i = 1

    while keepGoing and i <= nValue * 2:
      echo "while i: ", i
      ## x every square this queen can attack

      echo "x squares"
      for si, square in b:
        ## Don't check if we already know it can't be a queen
        if square.x == false:
          b[si].x = cannotBeQueen(square, qLoc)
          b[si].group = queens

      echo "try to add queen"
      ## Try to add another queen
      for i, square in b:
        if square.x == false:
          b[i].queen = true
          b[i].x = true
          queens += 1
          b[i].group = queens

          qLoc = (row: b[i].row, col: b[i].col)

          ## Catch successes
          if queens == nValue:
            validity = true
            ## keepGoing = false

          echo "BREAK!!!"
          break

        if i == b.len:
          echo "All Spaces Taken!!!"

      ## increment counter
      i += 1
  ]#

  ## Add a queen to each square in row 1
  for i in 0 .. nValue - 1:

    ## Copy board and find solutions
    ## for THIS board
    var b = board

    ## Add row 1 queen
    b[i].queen = true
    b[i].x = true
    b[i].group = 1

    var availableSquares: seq[int] = @[]

    ## x every square this queen can attack
    for si, square in b:
      ## Don't check if we already know it can't be a queen
      ## if square.x == false:
      b[si].x = cannotBeQueen(square, (row: b[i].row, col: b[i].col))
      b[si].group = 1

      if not b[si].x:
        availableSquares.add(si)

    echo "AVAILABLE SQUARES: ", $availableSquares


    ## for avSqIndex, n in availableSquares:
    echo "TESTING AVAILABLE SQUARE: ", n
    ## Capture current board
    var thisBoard = b
    ## echo "THIS BOARD: ", thisBoard

    ## Hold the currently available squares for this board
    var avSq = availableSquares

    ## Count the number of queens on this board
    var queens = 1
    ## Track this board's validity as a solution
    var validity = false

    var keepGoing = true
    var counter = b.len
    while keepGoing and counter > 0:

      ## Capture squares available in this while loop
      var av = avSq
      echo "WHILE available squares: ", av

      var addedQueen = addQueen(thisBoard, avSq[0], queens + 1)
      ## echo "ADDED QUEEN: ", addedQueen

      if addedQueen.availableSquares.len == 0:
        keepGoing = false
        echo "STOP!!!"

      queens += 1
      if queens == nValue:
        validity = true
        echo "ADD SOLUTION"
#[
        ## FOR NOW -- see what it looks like
        let newSoln = (board: thisBoard, valid: validity)
        solutions.add(newSoln)
        ## echo "solutions: ", $solutions
]#
      ## Update this board
      thisBoard = addedQueen.board

      ## Update available squares
      avSq = addedQueen.availableSquares

      counter -= 1

    ## FOR NOW -- see what it looks like
    let newSoln = (board: thisBoard, valid: validity)
    solutions.add(newSoln)
    ## echo "solutions: ", $solutions


      #[
      var keepGoing = true
      var i = 1
      while keepGoing and i <= 2:

        ## Capture current board
        var thisBoard = b
        ## and this board's available squares
        var tbas = availableSquares

        var validity = false
        var queens = 1
        var queenI = 1
        var qLoc = (row: 1, col: i+1)

        for i in 1 .. tbas.len - 1:
          if not thisBoard[i].x:
            echo "ADD QUEEN AT ", thisBoard[i]

            ## Start a new queen group color
            queens += 1

            thisBoard[i].queen = true
            thisBoard[i].x = true
            thisBoard[i].group = queens

            break

        ## x new queen's attackable squares

          i += 1
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
