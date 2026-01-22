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
            
            VStack(spacing: 25) {
                // MARK: - Header Title
                Text(didWin ? "LEVEL CLEAR!" : "GAME OVER!")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(didWin ? Color.yellow : Color.white)
                    .shadow(color: .black.opacity(0.5), radius: 0, x: 0, y: 4)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 0)
                    .padding(.top, 10)
                
                // MARK: - Score Display Area
                VStack(spacing: 6) {
                    Text("ROUND \(round)")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(.black.opacity(0.8))
                        .padding(.bottom, 5)
                    
                    Text("\(score)")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: 5)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(didWin ? Color.green.opacity(0.8) : Color.red.opacity(0.8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .strokeBorder(Color.white.opacity(0.4), lineWidth: 3)
                                )
                        )
                }
                
                .padding(.horizontal, 8)
                
                //Action Buttons
                VStack(spacing: 12) {
                    if didWin && round < 30 {
                        Button(action: {
                            dismiss()
                            onNext()
                        }) {
                            buttonContent(text: "NEXT LEVEL", icon: "arrow.right.circle.fill")
                        }
                        .buttonStyle(PuffyButtonStyle(color: CandyTheme.primaryGradient))
                    }
                    
                    Button(action: {
                        dismiss()
                        onRestart()
                    }) {
                        buttonContent(text: "RETRY", icon: "arrow.clockwise.circle.fill")
                            .fixedSize()
                    }
                    .buttonStyle(PuffyButtonStyle(color: CandyTheme.orangeGradient))
                    
                    Button(action: {
                        dismiss()
                        onExit()
                    }) {
                        buttonContent(text: "EXIT", icon: "xmark.circle.fill")
                        
                        
                    }
                    .buttonStyle(PuffyButtonStyle(color: CandyTheme.grayGradient))
                }
            }
            .padding(20)
            .modifier(CandyCard())
            .padding(30)
            .transition(.scale.combined(with: .opacity))
        }
    }
    
    private func buttonContent(text: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
            Text(text)
        }
        .font(.system(size: 18, weight: .black, design: .rounded))
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 54)
        .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 2)
    }
}

#Preview("Win State") {
    ZStack {
        CandyTheme.backgroundGradient.ignoresSafeArea()
        GameOverSheet(
            didWin: true,
            score: 1250,
            round: 1,
            onNext: {},
            onRestart: {},
            onExit: {}
        )
    }
}

#Preview("Loss State") {
    ZStack {
        CandyTheme.backgroundGradient.ignoresSafeArea()
        GameOverSheet(
            didWin: false,
            score: 450,
            round: 5,
            onNext: {},
            onRestart: {},
            onExit: {}
        )
    }
}
