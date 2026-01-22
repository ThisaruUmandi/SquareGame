import Foundation

struct ScoreCalculator {
    static func calculate(
        round: Int,
        moves: Int,
        timeRemaining: TimeInterval,
        maxMoves: Int
    ) -> Int {
        let baseScore = GameConstants.baseScore
        let timeBonus = Int(timeRemaining * GameConstants.timeFactor)
        let movePenalty = moves * GameConstants.movePenalty
        let roundBonus = round * GameConstants.roundBonusMultiplier
        
        let finalScore = baseScore + timeBonus - movePenalty + roundBonus
        return max(0, finalScore) // Never negative
    }
}
