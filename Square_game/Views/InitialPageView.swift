import SwiftUI

struct InitialPageView: View {
    @StateObject private var levelManager = LevelManager()
    @StateObject private var highScoreManager = HighScoreManager()
    @State private var showGame = false
    @State private var showMap = false
    @State private var showHighScores = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Vibrant background with depth
                CandyTheme.backgroundGradient.ignoresSafeArea()
                
                // Optional: Floating decorative circles for "Bubbles" effect
                Circle().fill(.white.opacity(0.1)).frame(width: 200).offset(x: -150, y: -230)
                Circle().fill(.white.opacity(0.1)).frame(width: 150).offset(x: -180, y: -140)
                
                
                // Optional: Floating decorative circles for "Bubbles" effect
                Circle().fill(.white.opacity(0.1)).frame(width: 200).offset(x: 150, y: 230)
                Circle().fill(.white.opacity(0.1)).frame(width: 150).offset(x: 180, y: 140)
                
                VStack(spacing: 50) {
                    // Title with heavy shadow and rounded design
                    VStack(spacing: 15) {
                        Text("CoLoRs")
                            .font(.system(size: 72, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.3), radius: 0, x: 0, y: 8)
                        
                        Text("ADVENTURE")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .tracking(8)
                            .foregroundColor(Color(hex: "daf7ff"))
                    }
                    .padding(.top, 160)
                    .padding(.bottom, 50)
                    
                    //Spacer()
                    
                    // Main Menu Buttons
                    VStack(spacing: 25) {
                        Button(action: {
                            levelManager.currentRound = levelManager.highestUnlockedRound
                            showGame = true
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("START GAME")
                            }
                            .frame(width: 250, height: 30)
                        }
                        .buttonStyle(PuffyButtonStyle(color: CandyTheme.primaryGradient))
                        
                        Button(action: { showMap = true }) {
                            HStack {
                                Image(systemName: "map.fill")
                                Text("LEVEL MAP")
                            }
                            .frame(width: 250, height: 30)
                        }
                        .buttonStyle(PuffyButtonStyle(color: LinearGradient(colors: [Color(hex: "4facfe"), Color(hex: "00f2fe")], startPoint: .top, endPoint: .bottom)))
                        
                        Button(action: { showHighScores = true }) {
                            HStack {
                                Image(systemName: "trophy.fill")
                                Text("HIGH SCORES")
                            }
                            .frame(width: 250, height: 30)
                        }
                        .buttonStyle(PuffyButtonStyle(color: LinearGradient(colors: [Color(hex: "f6d365"), Color(hex: "fda085")], startPoint: .top, endPoint: .bottom)))
                    }
                    
                    
                    Spacer()
                    
                }
            }
            .navigationDestination(isPresented: $showGame) {
                GameView(levelManager: levelManager, highScoreManager: highScoreManager)
            }
            .navigationDestination(isPresented: $showMap) {
                MapLevelView(levelManager: levelManager, highScoreManager: highScoreManager, showGame: $showGame)
            }
            .navigationDestination(isPresented: $showHighScores) {
                HighScoreView(highScoreManager: highScoreManager)
            }
        }
    }
}

#Preview {
    InitialPageView()
}
