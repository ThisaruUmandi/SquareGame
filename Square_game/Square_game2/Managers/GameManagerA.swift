import Foundation
import SwiftUI

class GameManagerA: ObservableObject {
    @Published var boardManager: BoardManagerA
    @Published var gameState: GameStateA
    @Published var scoreManager: ScoreManagerA
    
    private let matchManager = MatchManagerA()
    private let gravityManager = GravityManagerA()
    private let timeManager = TimeManagerA()
    
    private var currentLevel: Level
    private var isProcessing = false
    
    init(level: Level) {
        self.currentLevel = level
        self.boardManager = BoardManagerA(size: level.boardSize, candyTypes: level.candyTypes)
        self.gameState = GameStateA()
        self.scoreManager = ScoreManagerA()
        setupLevel(level)
    }
    
    func setupLevel(_ level: Level) {
        currentLevel = level
        boardManager = BoardManagerA(size: level.boardSize, candyTypes: level.candyTypes)
        boardManager.setupObstacles(hasJelly: level.hasJelly, hasIce: level.hasIce, hasBlockers: level.hasBlockers)
        gameState.reset(for: level)
        scoreManager.reset()
    }
    
    // MARK: - Game Controls
    
    func startGame() {
        gameState.status = .playing
        
        timeManager.start(duration: currentLevel.timeAllowed,
                          onTick: { [weak self] remaining in
            self?.gameState.timeRemaining = remaining
        },
                          onComplete: { [weak self] in
            self?.endGame()
        })
    }
    
    func pauseGame() {
        gameState.status = .paused
        timeManager.pause()
    }
    
    func resumeGame() {
        gameState.status = .playing
        timeManager.resume()
    }
    
    func restartLevel() {
        timeManager.reset()
        setupLevel(currentLevel)
        startGame()
    }
    
    private func endGame() {
        if gameState.score >= currentLevel.targetScore {
            gameState.status = .won
            calculateFinalScore()
        } else {
            gameState.status = .lost
        }
    }
    
    // MARK: - Swapping
    
    func handleSwap(_ pos1: Position, _ pos2: Position) {
        guard gameState.status == .playing && !isProcessing else { return }
        guard boardManager.canSwap(pos1, pos2) else { return }
        
        isProcessing = true
        
        // Perform swap
        boardManager.swap(pos1, pos2)
        
        // Check if this creates a match
        let matches = matchManager.findMatches(in: boardManager.board)
        
        if matches.isEmpty {
            // Invalid move - swap back
            DispatchQueue.main.asyncAfter(deadline: .now() + ConstantsA.swapDuration) { [weak self] in
                self?.boardManager.swap(pos1, pos2)
                self?.isProcessing = false
            }
        } else {
            // Valid move - process
            DispatchQueue.main.asyncAfter(deadline: .now() + ConstantsA.swapDuration) { [weak self] in
                guard let self = self else { return }
                
                // Decrement moves
                self.gameState.decrementMoves()
                
                // Check if out of moves
                if self.gameState.movesRemaining <= 0 && self.gameState.score < self.currentLevel.targetScore {
                    self.endGame()
                    self.isProcessing = false
                    return
                }
                
                // Start cascade
                self.processCascade()
            }
        }
    }
    
    // MARK: - Cascade Processing
    
    private func processCascade() {
        scoreManager.resetCombo()
        processCascadeStep()
    }
    
    private func processCascadeStep() {
        let matches = matchManager.findMatches(in: boardManager.board)
        
        if matches.isEmpty {
            // Cascade complete
            isProcessing = false
            
            // Check win condition
            if gameState.score >= currentLevel.targetScore {
                gameState.status = .won
                calculateFinalScore()
            }
            return
        }
        
        // Increment combo
        scoreManager.incrementCombo()
        
        // Add score
        scoreManager.addScore(for: matches)
        gameState.score = scoreManager.score
        
        // Clear matches
        gravityManager.clearMatches(matches: matches, from: boardManager.board)
        
        // Force UI update
        objectWillChange.send()
        
        // Wait for clear animation
        DispatchQueue.main.asyncAfter(deadline: .now() + ConstantsA.matchDuration) { [weak self] in
            guard let self = self else { return }
            
            // Apply gravity
            _ = self.gravityManager.applyGravity(to: self.boardManager.board, candyTypes: self.currentLevel.candyTypes)
            
            // Reset matched flags
            self.gravityManager.resetMatchedFlags(in: self.boardManager.board)
            
            // Force UI update
            self.objectWillChange.send()
            
            // Wait for fall animation
            DispatchQueue.main.asyncAfter(deadline: .now() + ConstantsA.fallDuration) { [weak self] in
                guard let self = self else { return }
                
                // Check for new matches (chain reaction)
                self.processCascadeStep()
            }
        }
    }
    
    // MARK: - Final Score
    
    private func calculateFinalScore() {
        timeManager.stop()
        scoreManager.addBonusScore(
            movesRemaining: gameState.movesRemaining,
            timeRemaining: gameState.timeRemaining
        )
        gameState.score = scoreManager.score
        gameState.calculateStars()
        currentLevel.saveStars(gameState.stars)
    }
}
