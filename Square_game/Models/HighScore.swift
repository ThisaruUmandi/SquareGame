import SwiftUI

struct HighScore: Identifiable, Codable {
    let id = UUID()
    let name: String
    let score: Int
    let date: Date
}
