import SwiftUI

struct HUDView: View {
    @ObservedObject var gameState: GameStateA
    let targetScore: Int
    let onPause: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Top bar
            HStack {
                // Back button
                Button(action: onPause) {
                    Image(systemName: "pause.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Circle().fill(Color.white.opacity(0.2)))
                }
                
                Spacer()
                
                // Score
                VStack(spacing: 4) {
                    Text("SCORE")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(gameState.score)")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                )
                
                Spacer()
                
                // Level
                VStack(spacing: 4) {
                    Text("LEVEL")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(gameState.currentLevel)")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                )
            }
            
            // Progress bar
            VStack(spacing: 4) {
                HStack {
                    Text("Target: \(targetScore)")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(Int(min(Double(gameState.score) / Double(targetScore) * 100, 100)))%")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 12)
                        
                        Capsule()
                            .fill(CandyTheme.successGradient)
                            .frame(width: geometry.size.width * min(Double(gameState.score) / Double(targetScore), 1.0), height: 12)
                    }
                }
                .frame(height: 12)
            }
            
            // Stats
            HStack(spacing: 20) {
                // Moves
                StatView(
                    icon: "arrow.left.arrow.right",
                    value: "\(gameState.movesRemaining)",
                    label: "MOVES",
                    color: gameState.movesRemaining < 5 ? CandyTheme.dangerGradient : CandyTheme.warningGradient
                )
                
                // Time
                StatView(
                    icon: "timer",
                    value: formatTime(gameState.timeRemaining),
                    label: "TIME",
                    color: gameState.timeRemaining < 30 ? CandyTheme.dangerGradient : CandyTheme.successGradient
                )
                
                // Combo
                if gameState.comboMultiplier > 1 {
                    StatView(
                        icon: "flame.fill",
                        value: "x\(gameState.comboMultiplier)",
                        label: "COMBO",
                        color: CandyTheme.primaryGradient
                    )
                }
            }
        }
        .padding()
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }
}

struct StatView: View {
    let icon: String
    let value: String
    let label: String
    let color: LinearGradient
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                Text(value)
                    .font(.system(size: 18, weight: .black, design: .rounded))
            }
            .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(color)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        )
    }
}

#Preview {
    ZStack {
        CandyTheme.gameBackgroundGradient
            .ignoresSafeArea()
        
        HUDView(
            gameState: {
                let state = GameStateA()
                state.score = 1500
                state.movesRemaining = 15
                state.timeRemaining = 45
                state.comboMultiplier = 3
                state.currentLevel = 5
                return state
            }(),
            targetScore: 2000,
            onPause: {}
        )
    }
}
