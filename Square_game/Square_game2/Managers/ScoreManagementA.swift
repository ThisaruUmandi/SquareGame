import Foundation

class ScoreManagerA: ObservableObject {
    @Published var score: Int = 0
    @Published var comboMultiplier: Int = 1
    
    func addScore(for matches: [Match]) {
        var totalScore = 0
        
        for match in matches {
            let baseScore = ScoreCalculatorA.calculateScore(for: match, combo: comboMultiplier)
            totalScore += baseScore
        }
        
        score += totalScore
    }
    
    func incrementCombo() {
        comboMultiplier = min(comboMultiplier + 1, ConstantsA.maxComboMultiplier)
    }
    
    func resetCombo() {
        comboMultiplier = 1
    }
    
    func addBonusScore(movesRemaining: Int, timeRemaining: Int) {
        let bonus = ScoreCalculatorA.calculateBonusScore(
            movesRemaining: movesRemaining,
            timeRemaining: timeRemaining
        )
        score += bonus
    }
    
    func reset() {
        score = 0
        comboMultiplier = 1
    }
}
