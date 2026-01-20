import SwiftUI

struct LevelConfig {
    let gridSize: Int
    let colors: [Color]
    let maxTime: Int
    let maxMoves: Int
}

class LevelManager: ObservableObject {
    @Published var round: Int = 1

    func currentLevelConfig() -> LevelConfig {
        switch round {
        case 1...10:
            return LevelConfig(gridSize: 3,
                               colors: [.red, .yellow, .green],
                               maxTime: 30,
                               maxMoves: 20)
        case 11...20:
            return LevelConfig(gridSize: 5,
                               colors: [.red, .yellow, .green, .blue],
                               maxTime: 60,
                               maxMoves: 40)
        default:
            return LevelConfig(gridSize: 7,
                               colors: [.red, .yellow, .green, .blue, .orange],
                               maxTime: 90,
                               maxMoves: 50)
        }
    }

    func nextRound() {
        round += 1
    }

    func resetRound() {
        // keep same round when player loses
    }
}
