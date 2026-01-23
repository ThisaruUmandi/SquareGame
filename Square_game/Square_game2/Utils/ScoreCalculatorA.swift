//import Foundation
//
//class ScoreCalculatorA {
//    static func calculateScore(for match: Match, combo: Int) -> Int {
//        let baseScore = match.score
//        let comboMultiplier = min(combo, ConstantsA.maxComboMultiplier)
//        return baseScore * comboMultiplier
//    }
//    
//    static func calculateBonusScore(movesRemaining: Int, timeRemaining: Int) -> Int {
//        return (movesRemaining * 100) + (timeRemaining * 10)
//    }
//    
//    static func calculateStars(score: Int, targetScore: Int) -> Int {
//        let percentage = Double(score) / Double(targetScore)
//        if percentage >= 2.0 {
//            return 3
//        } else if percentage >= 1.5 {
//            return 2
//        } else if percentage >= 1.0 {
//            return 1
//        } else {
//            return 0
//        }
//    }
//}

import Foundation

class ScoreCalculatorA {
    static func calculateScore(for match: Match, combo: Int) -> Int {
        let baseScore = match.score
        return baseScore * combo
    }
    
    static func calculateBonusScore(movesRemaining: Int, timeRemaining: Int) -> Int {
        let moveBonus = movesRemaining * ConstantsA.bonusPerMove
        let timeBonus = timeRemaining * ConstantsA.bonusPerSecond
        return moveBonus + timeBonus
    }
}
