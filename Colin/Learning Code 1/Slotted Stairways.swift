func collectGemTurnAround() {
    moveForward()
    moveForward()
    collectGem()
    turnLeft()
    turnLeft()
    moveForward()
    moveForward()
    moveForward()
    moveForward()
    collectGem()
}
func solveRow() {
  collectGemTurnAround()
  turnLeft()
  turnLeft()
  moveForward()
  moveForward()
  turnRight()
  moveForward()
  turnLeft()
}
solveRow()
solveRow()
solveRow()