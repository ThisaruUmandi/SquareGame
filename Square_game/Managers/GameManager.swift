import Foundation
import Combine

class GameManager: ObservableObject {
    @Published var gameState: GameState
    @Published var selectedTile: GridPosition?
    @Published var showNameEntry = false
    
    private var timer: Timer?
    private let levelManager: LevelManager
    private let highScoreManager: HighScoreManager
    
    init(levelManager: LevelManager, highScoreManager: HighScoreManager) {
        self.levelManager = levelManager
        self.highScoreManager = highScoreManager
        
        let config = levelManager.getCurrentConfig()
        self.gameState = GameState(
            currentRound: levelManager.currentRound,
            maxMoves: config.maxMoves,
            timeRemaining: config.timeLimit
        )
    }
    
    func startGame() {
        let config = levelManager.getCurrentConfig()
        
        gameState = GameState(
            currentRound: levelManager.currentRound,
            maxMoves: config.maxMoves,
            timeRemaining: config.timeLimit,
            grid: Grid.generate(size: config.gridSize, colorCount: config.colorCount)
        )
        
        selectedTile = nil
        showNameEntry = false
        startTimer()
    }
    
    func selectTile(at position: GridPosition) {
        if let selected = selectedTile {
            // Try to swap
            if Grid.swap(in: &gameState.grid, from: selected, to: position) {
                gameState.moves += 1
                checkGameStatus()
            }
            selectedTile = nil
        } else {
            selectedTile = position
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func updateTimer() {
        if gameState.timeRemaining > 0 {
            gameState.timeRemaining -= 1
        } else {
            handleGameOver(won: false)
        }
    }
    
    private func checkGameStatus() {
        // Check win
        if Grid.isSolved(gameState.grid) {
            handleGameOver(won: true)
            return
        }
        
        // Check loss conditions
        if gameState.moves >= gameState.maxMoves {
            handleGameOver(won: false)
        }
    }
    
    private func handleGameOver(won: Bool) {
        timer?.invalidate()
        gameState.isGameOver = true
        gameState.didWin = won
        
        if won {
            gameState.score = ScoreCalculator.calculate(
                round: gameState.currentRound,
                moves: gameState.moves,
                timeRemaining: gameState.timeRemaining,
                maxMoves: gameState.maxMoves
            )
            
            // Check if it's a high score
            if highScoreManager.isNewHighScore(round: gameState.currentRound, score: gameState.score) {
                showNameEntry = true
            }
        }
    }
    
    func saveHighScore(playerName: String) {
        highScoreManager.addScore(
            round: gameState.currentRound,
            score: gameState.score,
            playerName: playerName
        )
        showNameEntry = false
    }
    
    func moveToNextLevel() {
        levelManager.unlockNextRound()
        startGame()
    }
    
    func restartLevel() {
        startGame()
    }
    
    deinit {
        timer?.invalidate()
    }
}
