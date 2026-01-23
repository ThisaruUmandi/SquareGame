import Foundation

struct ConstantsA {
    // Animation durations
    static let swapDuration: Double = 0.25
    static let matchDuration: Double = 0.3
    static let fallDuration: Double = 0.4
    static let spawnDuration: Double = 0.2
    
    // Game settings
    static let minMatchCount = 3
    static let maxComboMultiplier: Int = 5
    
    // Scoring
    //static let maxComboMultiplier: Int = 5
    static let bonusPerMove: Int = 100
    static let bonusPerSecond: Int = 10
    
    // Match scoring
    static let threeMatchScore: Int = 60
    static let fourMatchScore: Int = 120
    static let fiveMatchScore: Int = 200
    static let specialMatchScore: Int = 300
    
    // Special candy thresholds
    static let stripedCandyMatch = 4
    static let bombCandyMatch = 5
    
    // Board sizes by level
    static func boardSize(for level: Int) -> Int {
        if level <= 5 {
            return 7
        } else if level <= 15 {
            return 8
        } else {
            return 9
        }
    }
    
    static func candyTypes(for level: Int) -> Int {
        if level <= 5 {
            return 4
        } else if level <= 15 {
            return 5
        } else if level <= 30 {
            return 6
        } else {
            return 7
        }
    }
}

