import SwiftUI

struct GameOverSheet: View {
    let didWin: Bool
    let score: Int
    let round: Int
    let onNext: () -> Void
    let onRestart: () -> Void
    let onExit: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            CandyTheme.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 40) {
//                Spacer()
                
                // MARK: - Header with Trophy/Emoji
                VStack(spacing: 16) {
                    Text(didWin ? "🏆" : "😔")
                        .font(.system(size: 60))
                        .shadow(color: .black.opacity(0.2), radius: 10)
                    
                    Text(didWin ? "Level Clear!" : "Game Over!")
                        .font(.system(size: 44, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 4)
                        .shadow(color: didWin ? .yellow.opacity(0.6) : .red.opacity(0.4), radius: 20)
                }
                
                // MARK: - Score Card
                VStack(spacing: 12) {
                    Text("ROUND \(round)")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .tracking(2)
                    
                    Text("\(score)")
                        .font(.system(size: 72, weight: .black, design: .rounded))
                        .foregroundColor(didWin ? Color(hex: "FFE135") : Color(hex: "FFE135"))
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 4)
                        .shadow(color: didWin ? Color(hex: "FFE135").opacity(0.5) : Color(hex: "FFE135").opacity(0.3), radius: 20)
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 50)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.white.opacity(0.3), lineWidth: 2)
                        )
                )
                .padding(.bottom,50)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                
//                Spacer()
                
                // MARK: - Action Buttons
                HStack(spacing: 24) {
                    if didWin && round < 30 {
                        Button(action: {
                            onNext()
                            dismiss()
                        }) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(
                                    ZStack {
                                        Circle()
                                            .fill(Color.black.opacity(0.15))
                                            .offset(y: 4)
                                        Circle()
                                            .fill(CandyTheme.primaryGradient)
                                        Circle()
                                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 3)
                                    }
                                )
                                .shadow(color: Color(hex: "FF6BBD").opacity(0.3), radius: 20)
                        }
                    }
                    
                    Button(action: {
                        dismiss()
                        onRestart()
                    }) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(
                                ZStack {
                                    Circle()
                                        .fill(Color.black.opacity(0.15))
                                        .offset(y: 4)
                                    Circle()
                                        .fill(CandyTheme.orangeGradient)
                                    Circle()
                                        .strokeBorder(Color.white.opacity(0.3), lineWidth: 3)
                                }
                            )
                            .shadow(color: Color(hex: "FF9500").opacity(0.3), radius: 20)
                    }
                    
                    Button(action: {
                        dismiss()
                        onExit()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(
                                ZStack {
                                    Circle()
                                        .fill(Color.black.opacity(0.15))
                                        .offset(y: 4)
                                    Circle()
                                        .fill(CandyTheme.grayGradient)
                                    Circle()
                                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 3)
                                }
                            )
                            .shadow(color: .black.opacity(0.3), radius: 15)
                    }
                }
                .padding(.bottom, 50)
            }
            .transition(.scale.combined(with: .opacity))
        }
    }
}

#Preview("Win State") {
    GameOverSheet(
        didWin: true,
        score: 1250,
        round: 1,
        onNext: {},
        onRestart: {},
        onExit: {}
    )
}

#Preview("Loss State") {
    GameOverSheet(
        didWin: false,
        score: 450,
        round: 5,
        onNext: {},
        onRestart: {},
        onExit: {}
    )
}
