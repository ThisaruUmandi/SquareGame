import Foundation

class LevelManager: ObservableObject {
    @Published var currentRound: Int = 1
    @Published var highestUnlockedRound: Int = 1
    
    func getCurrentConfig() -> (gridSize: Int, colorCount: Int, timeLimit: TimeInterval, maxMoves: Int) {
        return (
            gridSize: GameConstants.gridSize(for: currentRound),
            colorCount: GameConstants.colorCount(for: currentRound),
            timeLimit: GameConstants.timeLimit(for: currentRound),
            maxMoves: GameConstants.maxMoves(for: currentRound)
        )
    }
    
    func unlockNextRound() {
        if currentRound < 30 {
            currentRound += 1
            highestUnlockedRound = max(highestUnlockedRound, currentRound)
        }
    }
    
    func canPlayRound(_ round: Int) -> Bool {
        return round <= highestUnlockedRound
    }
    
    func selectRound(_ round: Int) {
        if canPlayRound(round) {
            currentRound = round
        }
    }
    
    func resetProgress() {
        currentRound = 1
        highestUnlockedRound = 1
    }
}
