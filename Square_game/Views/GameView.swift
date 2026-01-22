import SwiftUI

struct GameView: View {
    @StateObject private var gameManager: GameManager
    @Environment(\.dismiss) private var dismiss
    @Namespace private var gridAnimation // For the swap animation
    
    init(levelManager: LevelManager, highScoreManager: HighScoreManager) {
        _gameManager = StateObject(wrappedValue: GameManager(
            levelManager: levelManager,
            highScoreManager: highScoreManager
        ))
    }
    
    var body: some View {
        ZStack {
            CandyTheme.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                headerSection
                    .padding(.top, 40)
                    .padding(.bottom, 60)
                
                // MARK: - Grid
                GridView(
                    grid: gameManager.gameState.grid,
                    selectedTile: gameManager.selectedTile,
                    namespace: gridAnimation,
                    onTileTap: { position in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            gameManager.selectTile(at: position)
                        }
                    }
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.white, .white.opacity(0.3))
                }
                .padding(.bottom, 20)
            }
        } // End of ZStack
        .navigationBarBackButtonHidden(true)
        .onAppear { gameManager.startGame() }
        
        // MARK: - Game Over logic
        .fullScreenCover(isPresented: $gameManager.gameState.isGameOver) {
            GameOverSheet(
                didWin: gameManager.gameState.didWin,
                score: gameManager.gameState.score,
                round: gameManager.gameState.currentRound,
                onNext: { gameManager.moveToNextLevel() },
                onRestart: { gameManager.restartLevel() },
                onExit: { dismiss() }
            )
        }
        
        // MARK: - High Score Entry logic
        .sheet(isPresented: $gameManager.showNameEntry) {
            NameEntrySheet(
                score: gameManager.gameState.score,
                round: gameManager.gameState.currentRound,
                onSave: { name in
                    gameManager.saveHighScore(playerName: name)
                }
            )
        }
    } // End of Body
    
    private var headerSection: some View {
        HStack(spacing: -30) {
            StatBox(title: "SCORE", value: "\(gameManager.gameState.score)", icon: "star.fill", color: .yellow)
            StatBox(title: "MOVES", value: "\(gameManager.gameState.moves)/\(gameManager.gameState.maxMoves)", icon: "hand.tap.fill", color: .blue)
            StatBox(title: "TIME", value: "\(Int(gameManager.gameState.timeRemaining))s", icon: "timer", color: .orange)
        }
    }
}

// MARK: - StatBox
struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 14, weight: .black))
                Text(title).font(.system(size: 14, weight: .black))
            }
            .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - GridView
struct GridView: View {
    let grid: [[ColorTile]]
    let selectedTile: GridPosition?
    var namespace: Namespace.ID
    let onTileTap: (GridPosition) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let gridSize = min(geometry.size.width, geometry.size.height)
            let spacing: CGFloat = 10
            
            VStack(spacing: spacing) {
                ForEach(0..<grid.count, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<grid[row].count, id: \.self) { col in
                            let tile = grid[row][col]
                            let position = GridPosition(row: row, col: col)
                            
                            TileButton(
                                tile: tile,
                                isSelected: selectedTile == position,
                                namespace: namespace,
                                action: { onTileTap(position) }
                            )
                        }
                    }
                }
            }
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.15))
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.3), lineWidth: 3))
            )
            .frame(width: gridSize, height: gridSize)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - TileButton
struct TileButton: View {
    let tile: ColorTile
    let isSelected: Bool
    var namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(tile.color)
                .matchedGeometryEffect(id: tile.id, in: namespace)
                .shadow(color: .black.opacity(0.15), radius: 4, y: 4)
            
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(Color.white.opacity(0.4), lineWidth: 2)
            
            VStack {
                Capsule()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 6)
                    .padding(.horizontal, 8)
                    .padding(.top, 4)
                Spacer()
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.white : Color.clear, lineWidth: 4)
        )
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .onTapGesture { action() }
    }
}
#Preview {
    NavigationStack {
        GameView(
            levelManager: LevelManager(),
            highScoreManager: HighScoreManager()
        )
    }
}
