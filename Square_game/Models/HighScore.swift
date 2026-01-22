import Foundation

struct HighScore: Identifiable, Comparable, Equatable {
    let id = UUID()
    let round: Int
    let score: Int
    let playerName: String
    let date: Date
    
    static func < (lhs: HighScore, rhs: HighScore) -> Bool {
        lhs.score > rhs.score
    }
    
    static func == (lhs: HighScore, rhs: HighScore) -> Bool {
        lhs.id == rhs.id
    }
}
