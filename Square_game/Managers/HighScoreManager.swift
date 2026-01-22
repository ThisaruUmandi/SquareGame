import Foundation

class HighScoreManager: ObservableObject {
    @Published var scores: [HighScore] = []
    
    func addScore(round: Int, score: Int, playerName: String) {
        let newScore = HighScore(round: round, score: score, playerName: playerName, date: Date())
        scores.append(newScore)
        scores.sort()
    }
    
    func getTopScores(limit: Int = 10) -> [HighScore] {
        return Array(scores.prefix(limit))
    }
    
    func getTopScores(for round: Int, limit: Int = 10) -> [HighScore] {
        return scores
            .filter { $0.round == round }
            .sorted()
            .prefix(limit)
            .map { $0 }
    }
    
    func getBestScore(for round: Int) -> Int? {
        return scores
            .filter { $0.round == round }
            .max(by: { $0.score < $1.score })?
            .score
    }
    
    func isNewHighScore(round: Int, score: Int) -> Bool {
        let roundScores = scores.filter { $0.round == round }
        
        // If no scores yet for this round, it's a high score
        if roundScores.isEmpty {
            return true
        }
        
        // Check if this score would be in top 10 for this round
        let topScores = roundScores.sorted().prefix(10)
        if topScores.count < 10 {
            return true
        }
        
        // Check if better than the worst in top 10
        if let worstTopScore = topScores.last?.score {
            return score > worstTopScore
        }
        
        return false
    }
}
