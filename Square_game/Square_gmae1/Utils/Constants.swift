import Foundation

enum GameConstants {
    // Grid sizes
    static func gridSize(for round: Int) -> Int {
        switch round {
        case 1: return 3
        case 2...10: return 4
        case 11...20: return 5
        case 21...30: return 7
        default: return 3
        }
    }
    
    // Color counts (same as grid size)
    static func colorCount(for round: Int) -> Int {
        return gridSize(for: round)
    }
    
    // Time limits
    static func timeLimit(for round: Int) -> TimeInterval {
        switch round {
        case 1: return 15
        case 2...10: return 35
        case 11...20: return 60
        case 21...30: return 80
        default: return 15
        }
    }
    
    // Max moves (2x grid size seems reasonable)
    static func maxMoves(for round: Int) -> Int {
        let size = gridSize(for: round)
        return size * size
    }
    
    // Scoring
    static let baseScore = 100
    static let timeFactor = 10.0
    static let movePenalty = 2
    static let roundBonusMultiplier = 10
}
