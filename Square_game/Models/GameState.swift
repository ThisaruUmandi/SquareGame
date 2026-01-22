import Foundation

struct GameState {
    var currentRound: Int = 1
    var moves: Int = 0
    var maxMoves: Int
    var timeRemaining: TimeInterval
    var score: Int = 0
    var isGameOver: Bool = false
    var didWin: Bool = false
    var grid: [[ColorTile]] = []
}
