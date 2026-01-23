//import SwiftUI
//
//struct MapLevelView: View {
//    @ObservedObject var levelManager: LevelManager
//    @ObservedObject var highScoreManager: HighScoreManager
//    @Binding var showGame: Bool
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        ZStack {
//            CandyTheme.backgroundGradient.ignoresSafeArea()
//            
//            ScrollView(showsIndicators: false) {
//                VStack(spacing: 0) {
//                    Text("LEVEL MAP")
//                        .font(.system(size: 44, weight: .black, design: .rounded))
//                        .foregroundColor(.white)
//                        .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 5)
//                        .padding(.top, 60)
//                    
//                    ZStack {
//                        // The Dotted Path Line
//                        Path { path in
//                            path.move(to: CGPoint(x: 200, y: 100))
//                            for i in 1...30 {
//                                let x = 200 + sin(Double(i) * 0.8) * 80
//                                path.addLine(to: CGPoint(x: x, y: CGFloat(i * 120 + 100)))
//                            }
//                        }
//                        .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: [1, 15]))
//                        
//                        VStack(spacing: 50) {
//                            ForEach((1...30), id: \.self) { round in
//                                LevelNode(
//                                    round: round,
//                                    isUnlocked: levelManager.canPlayRound(round),
//                                    isCurrent: round == levelManager.currentRound,
//                                    bestScore: highScoreManager.getBestScore(for: round)
//                                ) {
//                                    levelManager.selectRound(round)
//                                    dismiss()
//                                    showGame = true
//                                }
//                                .offset(x: CGFloat(sin(Double(round) * 0.8) * 80))
//                            }
//                        }
//                        .padding(.vertical, 80)
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct LevelNode: View {
//    let round: Int
//    let isUnlocked: Bool
//    let isCurrent: Bool
//    let bestScore: Int?
//    var action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            VStack {
//                ZStack {
//                    Circle()
//                        .fill(isUnlocked ? CandyTheme.primaryGradient : LinearGradient(colors: [.gray], startPoint: .top, endPoint: .bottom))
//                        .frame(width: 70, height: 70)
//                        .shadow(color: .black.opacity(0.2), radius: 5, y: 5)
//                    
//                    if isUnlocked {
//                        Text("\(round)")
//                            .font(.system(size: 28, weight: .black, design: .rounded))
//                            .foregroundColor(.white)
//                    } else {
//                        Image(systemName: "lock.fill").foregroundColor(.white)
//                    }
//                    
//                    if isCurrent {
//                        Circle()
//                            .strokeBorder(Color.white, lineWidth: 5)
//                            .frame(width: 85, height: 85)
//                    }
//                }
//                
//                if let score = bestScore {
//                    Text("\(score) pts")
//                        .font(.system(size: 12, weight: .bold))
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 8)
//                        .background(Color.black.opacity(0.3))
//                        .cornerRadius(10)
//                }
//            }
//        }
//        .disabled(!isUnlocked)
//    }
//}
import SwiftUI

struct MapLevelView: View {
    @ObservedObject var levelManager: LevelManager
    @ObservedObject var highScoreManager: HighScoreManager
    @Binding var showGame: Bool
    @Environment(\.dismiss) private var dismiss
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 5)
    
    var body: some View {
        ZStack {
            CandyTheme.backgroundGradient.ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Text("LEVELS")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .padding()

                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(1...30, id: \.self) { round in
                            Button(action: {
                                levelManager.selectRound(round)
                                dismiss()
                                showGame = true
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(levelManager.canPlayRound(round) ? CandyTheme.primaryGradient : LinearGradient(colors: [.gray], startPoint: .top, endPoint: .bottom))
                                        .frame(width: 60, height: 60)
                                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                    
                                    if !levelManager.canPlayRound(round) {
                                        Image(systemName: "lock.fill").foregroundColor(.white.opacity(0.5))
                                    } else {
                                        Text("\(round)").font(.headline).foregroundColor(.white)
                                    }
                                }
                            }
                            .disabled(!levelManager.canPlayRound(round))
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
#Preview {
    NavigationStack {
        MapLevelView(
            levelManager: LevelManager(),
            highScoreManager: HighScoreManager(),
            showGame: .constant(false)
        )
    }
}
