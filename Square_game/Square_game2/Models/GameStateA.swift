import Foundation

enum GameStatusA {
    case ready
    case playing
    case paused
    case won
    case lost
}

class GameStateA: ObservableObject {
    @Published var status: GameStatusA = .ready
    @Published var score: Int = 0
    @Published var movesRemaining: Int = 0
    @Published var timeRemaining: Int = 0
    @Published var targetScore: Int = 0
    @Published var currentLevel: Int = 1
    @Published var comboMultiplier: Int = 1
    @Published var stars: Int = 0
    
    func reset(for level: Level) {
        status = .ready
        score = 0
        movesRemaining = level.movesAllowed
        timeRemaining = Int(level.timeAllowed)
        targetScore = level.targetScore
        comboMultiplier = 1
        stars = 0
    }
    
    func decrementMoves() {
        if movesRemaining > 0 {
            movesRemaining -= 1
            if movesRemaining == 0 && score < targetScore {
                status = .lost
            }
        }
    }
    
    func decrementTime() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            if timeRemaining == 0 && score < targetScore {
                status = .lost
            }
        }
    }
    
    func addScore(_ points: Int) {
        score += points * comboMultiplier
        if score >= targetScore && status == .playing {
            status = .won
            calculateStars()
        }
    }
    
    func incrementCombo() {
        comboMultiplier = min(comboMultiplier + 1, 5)
    }
    
    func resetCombo() {
        comboMultiplier = 1
    }
    
    func calculateStars() {
        let scorePercentage = Double(score) / Double(targetScore)
        if scorePercentage >= 2.0 {
            stars = 3
        } else if scorePercentage >= 1.5 {
            stars = 2
        } else {
            stars = 1
        }
    }
}
