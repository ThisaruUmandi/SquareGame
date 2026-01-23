import SwiftUI

struct HighScoreView: View {
    @ObservedObject var highScoreManager: HighScoreManager
    @State private var showAllScores = true
    @State private var selectedRound: Int = 1
    
    var body: some View {
        ZStack {
            CandyTheme.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Title
                Text("HIGH SCORES")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: 4)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                
                // MARK: - Custom Segmented Control
                HStack(spacing: 0) {
                    TabBtn(text: "GLOBAL", active: showAllScores) { showAllScores = true }
                    TabBtn(text: "ROUNDS", active: !showAllScores) { showAllScores = false }
                }
                .padding(4)
                .background(Color.black.opacity(0.2))
                .cornerRadius(18)
                .padding(.horizontal, 20)
                .padding(.bottom, 15)

                // MARK: - Round Selector
                if !showAllScores {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(1...30, id: \.self) { round in
                                Button(action: { selectedRound = round }) {
                                    Text("\(round)")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        // FIX: Wrap Color in a LinearGradient to match types
                                        .background(
                                            selectedRound == round ?
                                            CandyTheme.primaryGradient :
                                            LinearGradient(colors: [Color.white.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                                        )
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 15)
                }

                // MARK: - Score List
                ScrollView {
                    VStack(spacing: 12) {
                        let scoresToDisplay = showAllScores ?
                            highScoreManager.getTopScores() :
                            highScoreManager.getTopScores(for: selectedRound)
                        
                        if scoresToDisplay.isEmpty {
                            Text(showAllScores ? "No Legends Yet!" : "No scores for Round \(selectedRound)")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.gray)
                                .padding(40)
                        } else {
                            ForEach(Array(scoresToDisplay.enumerated()), id: \.element.id) { index, score in
                                ScoreRow(rank: index + 1, score: score)
                            }
                        }
                    }
                    .padding(16)
                }
                .modifier(CandyCard())
                .padding(16)
            }
        }
    }
}

// MARK: - Helper Views

struct ScoreRow: View {
    let rank: Int
    let score: HighScore
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Text("\(rank)")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(rankColor(rank))
                    .frame(width: 28)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(score.playerName)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    Text("Round \(score.round) • \(score.date, style: .date)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(score.score)")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(Color(hex: "DB1392"))
            }
            .padding(.vertical, 10)
            
            Divider()
        }
    }
    
    private func rankColor(_ rank: Int) -> Color {
        switch rank {
        case 1: return .yellow
        case 2: return Color(hex: "C0C0C0")
        case 3: return Color(hex: "CD7F32")
        default: return .gray
        }
    }
}

struct TabBtn: View {
    let text: String
    let active: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 13, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                // This correctly uses two LinearGradients
                .background(active ? CandyTheme.primaryGradient : LinearGradient(colors: [.clear], startPoint: .top, endPoint: .bottom))
                .cornerRadius(14)
        }
    }
}

#Preview {
    NavigationStack {
        HighScoreView(highScoreManager: {
            let manager = HighScoreManager()
            manager.addScore(round: 1, score: 450, playerName: "Alice")
            manager.addScore(round: 1, score: 380, playerName: "Bob")
            manager.addScore(round: 5, score: 520, playerName: "Charlie")
            manager.addScore(round: 10, score: 600, playerName: "Diana")
            return manager
        }())
    }
}

//// MARK: - Custom Segmented Control
//HStack(spacing: 0) {
//    TabBtn(text: "GLOBAL", active: showAllScores) { showAllScores = true }
//    TabBtn(text: "ROUNDS", active: !showAllScores) { showAllScores = false }
//}
//.padding(4)
//.background(Color.black.opacity(0.2))
//.cornerRadius(18)
//.padding(.horizontal, 20)
//.padding(.bottom, 15)

