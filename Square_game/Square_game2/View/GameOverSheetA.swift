import SwiftUI

struct GameOverSheetA: View {
    let score: Int
    let targetScore: Int
    let onRestart: () -> Void
    let onQuit: () -> Void
    
    @State private var animate = false
    
    var didWin: Bool {
        score >= targetScore
    }
    
    var body: some View {
        ZStack {
            CandyTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Icon
                ZStack {
                    Circle()
                        .fill(didWin ? CandyTheme.successGradient : CandyTheme.dangerGradient)
                        .frame(width: 120, height: 120)
                        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: didWin ? "star.fill" : "xmark")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(animate ? 1.0 : 0.5)
                .rotationEffect(.degrees(animate ? 0 : -180))
                
                // Title
                Text(didWin ? "Level Complete!" : "Game Over")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                
                // Score card
                VStack(spacing: 15) {
                    HStack {
                        Text("Your Score:")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text("\(score)")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    HStack {
                        Text("Target Score:")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text("\(targetScore)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .padding(25)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.2))
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 15) {
                    Button(action: onRestart) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .font(.title3)
                            Text("TRY AGAIN")
                                .font(.system(size: 20, weight: .black, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                    }
                    .buttonStyle(PuffyButtonStyle(color: CandyTheme.warningGradient))
                    
                    Button(action: onQuit) {
                        HStack {
                            Image(systemName: "house.fill")
                                .font(.title3)
                            Text("QUIT")
                                .font(.system(size: 20, weight: .black, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                    }
                    .buttonStyle(PuffyButtonStyle(color: CandyTheme.grayGradient))
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                animate = true
            }
        }
    }
}

#Preview {
    GameOverSheetA(
        score: 1500,
        targetScore: 2000,
        onRestart: {},
        onQuit: {}
    )
}
