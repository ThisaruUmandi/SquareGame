import SwiftUI

struct LevelCompleteSheet: View {
    let level: Int
    let score: Int
    let stars: Int
    let onNext: () -> Void
    let onReplay: () -> Void
    
    @State private var animateStars = false
    @State private var animateScore = false
    
    var body: some View {
        ZStack {
            CandyTheme.successGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Confetti effect (simulated with emojis)
//                ZStack {
//                    ForEach(0..<20, id: \.self) { index in
//                        Text(["🎉", "⭐️", "🍬", "🍭"].randomElement() ?? "🎉")
//                            .font(.system(size: 30))
//                            .offset(
//                                x: CGFloat.random(in: -150...150),
//                                y: animateScore ? CGFloat.random(in: -200...200) : -300
//                            )
//                            .opacity(animateScore ? 0 : 1)
//                            .animation(
//                                .easeOut(duration: 2.0)
//                                    .delay(Double(index) * 0.05),
//                                value: animateScore
//                            )
//                    }
//                }
                
                // Title
                VStack(spacing: 10) {
                    Text("Level \(level)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("Complete!")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                
                // Stars
                HStack(spacing: 15) {
                    ForEach(0..<3, id: \.self) { index in
                        Image(systemName: index < stars ? "star.fill" : "star")
                            .font(.system(size: 50))
                            .foregroundColor(index < stars ? Color(hex: "FFD700") : .white.opacity(0.3))
                            .scaleEffect(animateStars && index < stars ? 1.2 : 0.5)
                            .animation(
                                .spring(response: 0.5, dampingFraction: 0.6)
                                    .delay(Double(index) * 0.2),
                                value: animateStars
                            )
                    }
                }
                .padding(.vertical, 20)
                
                // Score display
                VStack(spacing: 15) {
                    Text("Final Score")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("\(score)")
                        .font(.system(size: 56, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white.opacity(0.2))
                        .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
                )
                .scaleEffect(animateScore ? 1.0 : 0.8)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 15) {
                    Button(action: onNext) {
                        HStack {
                            Text("CONTINUE")
                                .font(.system(size: 22, weight: .black, design: .rounded))
                            Image(systemName: "chevron.right")
                                .font(.title3)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                    }
                    .buttonStyle(PuffyButtonStyle(color: CandyTheme.primaryGradient))
                    
                    Button(action: onReplay) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .font(.title3)
                            Text("REPLAY")
                                .font(.system(size: 18, weight: .heavy, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                    }
                    .buttonStyle(PuffyButtonStyle(color: CandyTheme.warningGradient))
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animateStars = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    animateScore = true
                }
            }
        }
    }
}

#Preview {
    LevelCompleteSheet(
        level: 5,
        score: 3500,
        stars: 3,
        onNext: {},
        onReplay: {}
    )
}
