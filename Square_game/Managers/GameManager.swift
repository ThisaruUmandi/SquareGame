import SwiftUI
import Combine

class GameManager: ObservableObject {
    @Published var grid: [[Color]] = []
    @Published var moves: Int = 0
    @Published var timeRemaining: Int = 0
    @Published var score: Int = 0
    @Published var showGameOverSheet: Bool = false
    @Published var didWin: Bool = false

    var maxMoves: Int = 0
    var timer: Timer?

    @ObservedObject var levelManager: LevelManager

    init(levelManager: LevelManager) {
        self.levelManager = levelManager
        startLevel()
    }

    func startLevel() {
        let config = levelManager.currentLevelConfig()
        generateGrid(colors: config.colors, size: config.gridSize)
        moves = 0
        maxMoves = config.maxMoves
        timeRemaining = config.maxTime
        didWin = false
        showGameOverSheet = false
        startTimer()
    }

    func restartLevel() {
        stopTimer()
        startLevel()
    }

    func nextLevel() {
        stopTimer()
        levelManager.nextRound()
        startLevel()
    }

    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.endGame(win: false)
                }
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
    }

    func generateGrid(colors: [Color], size: Int) {
        let totalCells = size * size
        let colorCount = colors.count
        let timesEachColor = totalCells / colorCount
        var pool: [Color] = []

        for color in colors {
            pool.append(contentsOf: Array(repeating: color, count: timesEachColor))
        }

        let leftover = totalCells - pool.count
        for _ in 0..<leftover {
            pool.append(colors.randomElement()!)
        }

        pool.shuffle()

        grid = []
        for r in 0..<size {
            var row: [Color] = []
            for c in 0..<size {
                row.append(pool.removeFirst())
            }
            grid.append(row)
        }
    }

    func swapTiles(r1: Int, c1: Int, r2: Int, c2: Int) {
        let temp = grid[r1][c1]
        grid[r1][c1] = grid[r2][c2]
        grid[r2][c2] = temp
        moves += 1
        checkWin()
        if moves >= maxMoves && !didWin {
            endGame(win: false)
        }
    }

    func checkWin() {
        let colorsInLevel = Set(grid.flatMap { $0 })
        let size = grid.count

        for color in colorsInLevel {
            let rowWin = grid.contains { row in row.allSatisfy { $0 == color } }
            let colWin = (0..<size).contains { c in (0..<size).allSatisfy { r in grid[r][c] == color } }
            if !(rowWin || colWin) { return } // This color not aligned yet
        }

        // All colors aligned vertically or horizontally → win
        calculateScore()
        endGame(win: true)
    }

    func calculateScore() {
        // Base points + move bonus + time bonus
        let base = grid.count * 100
        var bonus = 0
        if moves <= maxMoves { bonus += 50 }
        bonus += timeRemaining
        score += base + bonus
    }

    func endGame(win: Bool) {
        stopTimer()
        didWin = win
        showGameOverSheet = true
    }
}
