include karax / prelude

type
  Square = tuple[row: int, col: int, black: bool, queen: bool, x: bool, group: int]
  Board = seq[Square]
  Pair = tuple[row: int, col: int]
  Solution = tuple[board: Board, valid: bool]

var
  nValue: int = 0
  solutions: seq[Solution] = @[]

proc buildBoard(): Board =
  var board: seq[Square] = @[]
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

proc addQueen(boardIndex: int, group: int): Pair =
  ## Put a queen in the first available square.
  for i, s in solutions[boardIndex].board:
    if s.x == false:
      solutions[boardIndex].board[i].queen = true
      solutions[boardIndex].board[i].x = true
      solutions[boardIndex].board[i].group = group

      return (row: s.row, col: s.col)

proc getDiagonals(b: Board, qLoc: Pair): seq[Pair] =
  ## type Pair = tuple[row: int, col: int]
  var diagonals: seq[Pair] = @[]
  for sq in 1 .. nValue - 1:
    ## Positive
    let pCol = qLoc.col + sq
    if pCol <= nValue:
      let newPos = (row: qLoc.row + sq, col: pCol)
      diagonals.add(newPos)
    ## Negative
    let nCol = qLoc.col - sq
    if nCol > 0:
      let newNeg = (row: qLoc.row + sq, col: nCol)
      diagonals.add(newNeg)

  return diagonals

proc checkDiagonal(s: Square, diagonals: seq[Pair]): bool =
  for d in diagonals:
    if s.row == d.row and s.col == d.col:
      return true

## Show which spaces cannot contain a queen
proc cannotBeQueen(i: int, s: Square, qLoc: Pair, diagonals: seq[Pair]): bool =
  if s.row == qLoc.row:
    ## Horizontal
    return true
  elif s.col == qLoc.col:
    ## Vertical
    return true
  elif checkDiagonal(s, diagonals):
    ## Diagonal
    return true
  else:
    return false

proc findSolutions(n: int) =
  echo "find solutions when n is ", nValue

  ## Clear old solutions
  solutions = @[]

  for n in 1 .. nValue:
    ## Build a board
    var board = buildBoard();

    ## Assign a queen to one of the top row spaces
    board[n - 1].queen = true

    ## Add board to solutions
    let newSoln = (board: board, valid: false)
    solutions.add(newSoln)
    ## echo "solutions: ", $solutions

  ## Go through each possible solution
  for index, solution in solutions:
    var board = solutions[index].board
    #[
      Keep adding queens
      until solution is verified
      (n queens on board or fail)
    ]#
    var
      tries = 0
      queens = 1

    while tries <= board.len - 1:
      echo "while tries ", tries
      echo "queens: ", queens

      var
        queenAdded = (row: 0, col: 0)
        qLoc = (row: 0, col: 0)

      ## Get (or set) current queen location
      for sqI, sq in solutions[index].board:
        if sq.queen == true:
          qLoc = (row: sq.row, col: sq.col)

      ## Generate diagonals
      var diagonals = getDiagonals(board, qLoc)

      for si, square in solutions[index].board:
        ## Don't check if we already know it can't be a queen
        if square.x == false:
          solutions[index].board[si].x = cannotBeQueen(si + 1, square, qLoc, diagonals)
          solutions[index].board[si].group = queens

      ## Try to add another queen
      queenAdded = addQueen(index, queens + 1)
      if queenAdded.row == 0:
        break

      if queenAdded.row != 0:
        queens += 1
        qLoc = queenAdded

        if queens == nValue:
          solutions[index].valid = true

      ## Avoid infinite loop
      tries += 1


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
