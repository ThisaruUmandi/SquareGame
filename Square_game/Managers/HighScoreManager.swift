import SwiftUI

class HighScoreManager: ObservableObject {
    @Published var highScores: [HighScore] = []

    private let key = "highScores"

    init() {
        loadScores()
    }

    func addScore(name: String, score: Int) {
        let newScore = HighScore(name: name, score: score, date: Date())
        highScores.append(newScore)
        highScores.sort { $0.score > $1.score }
        if highScores.count > 10 {
            highScores.removeLast()
        }
        saveScores()
    }

    private func saveScores() {
        if let encoded = try? JSONEncoder().encode(highScores) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func loadScores() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([HighScore].self, from: data) {
            highScores = decoded
        }
    }
}
