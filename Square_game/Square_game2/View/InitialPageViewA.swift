import SwiftUI

struct InitialPageViewA: View {
    @State private var showGameViewA = false
    @State private var showLevelMap = false
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Background
            CandyTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Title
                VStack(spacing: 10) {
                    Text("FrUtieS")
                        .font(.system(size: 50, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, Color(hex: "FFD700")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .scaleEffect(animate ? 1.1 : 1.0)
                    
                    Text("Welcome to the FruitieS world!")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(0.9)
                }
                
                // Animated candy icons
                HStack(spacing: 20) {
                    ForEach(0..<5, id: \.self) { index in
                        Text(CandyType.allCases[index].emoji)
                            .font(.system(size: 50))
                            .rotationEffect(.degrees(animate ? 360 : 0))
                            .animation(
                                Animation.linear(duration: 2)
                                    .repeatForever(autoreverses: false)
                                    .delay(Double(index) * 0.1),
                                value: animate
                            )
                    }
                }
                .padding(.vertical, 20)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 20) {
                    // Play Button -> GameViewA
                    Button(action: {
                        showGameViewA = true
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                                .font(.title2)
                            Text("PLAY")
                                .font(.system(size: 28, weight: .black, design: .rounded))
                        }
                        .padding(.horizontal, 80)
                        .padding(.vertical, 2)
                    }
                    .buttonStyle(PuffyButtonStyle(color: CandyTheme.successGradient))
                    .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
                    
                    // Map Button -> MapLevelViewA
                    Button(action: {
                        showLevelMap = true
                    }) {
                        HStack {
                            Image(systemName: "map.fill")
                                .font(.title2)
                            Text("MAP")
                                .font(.system(size: 28, weight: .black, design: .rounded))
                        }
                        .padding(.horizontal, 80)
                        .padding(.vertical, 2)
                    }
                    .buttonStyle(PuffyButtonStyle(color: CandyTheme.primaryGradient))
                    .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
                }
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showGameViewA) {
            GameViewA(level: Level(
                number: 1,
                boardSize: 7,
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
        .fullScreenCover(isPresented: $showLevelMap) {
            MapLevelViewA()
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    InitialPageViewA()
}
