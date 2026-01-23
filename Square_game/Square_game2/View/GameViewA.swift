import SwiftUI

struct GameViewA: View {
    @StateObject private var gameManager: GameManagerA
    @State private var selectedPosition: Position?
    @State private var showGameOver = false
    @State private var showLevelComplete = false
    @Environment(\.dismiss) private var dismiss
    
    let level: Level
    
    init(level: Level) {
        self.level = level
        _gameManager = StateObject(wrappedValue: GameManagerA(level: level))
    }
    
    var body: some View {
        ZStack {
            CandyTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // HUD
                HUDView(
                    gameState: gameManager.gameState,
                    targetScore: level.targetScore,
                    onPause: {
                        gameManager.pauseGame()
                        showGameOver = true
                    }
                )
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                
                Spacer()
                
                // Game Board - OBSERVE the board properly
                BoardView(
                    board: gameManager.boardManager.board,
                    selectedPosition: $selectedPosition,
                    onTileSelected: handleTileSelection
                )
                .padding()
                
                Spacer()
            }
        }
        .onAppear {
            gameManager.startGame()
        }
        .onChange(of: gameManager.gameState.status) { oldValue, newValue in
            print("Game status changed: \(newValue)")
            if newValue == .won {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showLevelComplete = true
                }
            } else if newValue == .lost {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showGameOver = true
                }
            }
        }
        .onChange(of: gameManager.gameState.score) { oldValue, newValue in
            print("Score changed: \(newValue) / \(level.targetScore)")
            if newValue >= level.targetScore {
                showLevelComplete = true
            }
        }
        .onChange(of: gameManager.gameState.movesRemaining) { oldValue, newValue in
            print("Moves remaining: \(newValue)")
            if newValue <= 0 && gameManager.gameState.score < level.targetScore {
                showGameOver = true
            }
        }
        .onChange(of: gameManager.gameState.timeRemaining) { oldValue, newValue in
            print("Time remaining: \(newValue)")
            if newValue <= 0 && gameManager.gameState.score < level.targetScore {
                showGameOver = true
            }
        }
        .fullScreenCover(isPresented: $showGameOver) {
            GameOverSheetA(
                score: gameManager.gameState.score,
                targetScore: level.targetScore,
                onRestart: {
                    showGameOver = false
                    gameManager.restartLevel()
                },
                onQuit: {
                    dismiss()
                }
            )
        }
        .fullScreenCover(isPresented: $showLevelComplete) {
            LevelCompleteSheet(
                level: level.number,
                score: gameManager.gameState.score,
                stars: gameManager.gameState.stars,
                onNext: {
                    dismiss()
                },
                onReplay: {
                    showLevelComplete = false
                    gameManager.restartLevel()
                }
            )
        }
    }
    
    private func handleTileSelection(_ position: Position) {
        guard gameManager.gameState.status == .playing else { return }
        
        if let selected = selectedPosition {
            if selected == position {
                // Deselect
                selectedPosition = nil
            } else if selected.isAdjacent(to: position) {
                // Valid swap attempt
                gameManager.handleSwap(selected, position)
                selectedPosition = nil
            } else {
                // Select new position
                selectedPosition = position
            }
        } else {
            selectedPosition = position
        }
    }
}

struct BoardView: View {
    @ObservedObject var board: Board  // CRITICAL: Observe the board
    @Binding var selectedPosition: Position?
    let onTileSelected: (Position) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let tileSize = size / CGFloat(board.rows) - 4
            
            VStack(spacing: 4) {
                ForEach(0..<board.rows, id: \.self) { row in
                    HStack(spacing: 4) {
                        ForEach(0..<board.cols, id: \.self) { col in
                            let position = Position(row: row, col: col)
                            // Access tiles directly - will update when board publishes
                            TileView(
                                tile: board.tiles[row][col],
                                size: tileSize,
                                isSelected: selectedPosition == position,
                                onTap: { onTileSelected(position) }
                            )
                            .id("\(row)-\(col)-\(board.tiles[row][col].id)")  // Force refresh on tile change
                        }
                    }
                }
            }
            .frame(width: size, height: size)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

struct TileView: View {
    let tile: Tile
    let size: CGFloat
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: size * 0.2)
                    .fill(
                        tile.state.isBlocked ?
                            Color.gray.opacity(0.5) :
                            Color.white.opacity(0.3)
                    )
                    .frame(width: size, height: size)
                
                // Jelly overlay
                if case .jelly(let layers) = tile.state {
                    RoundedRectangle(cornerRadius: size * 0.2)
                        .fill(CandyTheme.jellyGradient.opacity(0.6))
                        .frame(width: size, height: size)
                    
                    if layers > 1 {
                        Text("\(layers)")
                            .font(.system(size: size * 0.3, weight: .bold))
                            .foregroundColor(.white)
                            .offset(x: size * 0.3, y: -size * 0.3)
                    }
                }
                
                // Ice overlay
                if case .ice(let layers) = tile.state {
                    RoundedRectangle(cornerRadius: size * 0.2)
                        .strokeBorder(Color.cyan, lineWidth: 3)
                        .frame(width: size, height: size)
                    
                    if layers > 1 {
                        Text("\(layers)")
                            .font(.system(size: size * 0.3, weight: .bold))
                            .foregroundColor(.cyan)
                            .offset(x: size * 0.3, y: -size * 0.3)
                    }
                }
                
                // Candy
                if let candy = tile.candy {
                    CandyView(candy: candy, size: size * 0.7)
                        .transition(.scale.combined(with: .opacity))
                }
                
                // Selection indicator
                if isSelected {
                    RoundedRectangle(cornerRadius: size * 0.2)
                        .strokeBorder(Color.yellow, lineWidth: 4)
                        .frame(width: size, height: size)
                        .animation(.easeInOut(duration: 0.3), value: isSelected)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.3), value: tile.candy?.id)
    }
}

struct CandyView: View {
    let candy: Candy
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(candy.type.color.gradient)
                .frame(width: size, height: size)
                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
            
            Text(candy.type.emoji)
                .font(.system(size: size * 0.7))
            
            // Special candy indicators
            switch candy.specialType {
            case .striped(let direction):
                Rectangle()
                    .fill(Color.white.opacity(0.7))
                    .frame(
                        width: direction == .horizontal ? size : 3,
                        height: direction == .vertical ? size : 3
                    )
            case .bomb:
                Image(systemName: "flame.fill")
                    .font(.system(size: size * 0.4))
                    .foregroundColor(.white)
            case .colorBomb:
                Circle()
                    .strokeBorder(
                        AngularGradient(
                            colors: CandyTheme.rainbowColors,
                            center: .center
                        ),
                        lineWidth: 3
                    )
                    .frame(width: size, height: size)
            case .none:
                EmptyView()
            }
        }
    }
}

#Preview {
    GameViewA(level: Level(
        number: 1,
        boardSize: 5,
        candyTypes: 4,
        movesAllowed: 30,
        timeAllowed: 120,
        targetScore: 1000,
        objective: .reachScore,
        hasJelly: false,
        hasIce: false,
        hasBlockers: false
    ))
}
