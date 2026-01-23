import SwiftUI

struct MapLevelViewA: View {
    @StateObject private var levelManager = LevelManagerA()
    @State private var selectedLevel: Level?
    @State private var showGame = false
    @Environment(\.dismiss) private var dismiss
    
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 20)
    ]
    
    var body: some View {
        ZStack {
            CandyTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                    
                    Spacer()
                    
                    Text("Select Level")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Color.clear.frame(width: 60)
                }
                .padding()
                
                // Level grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(levelManager.levels, id: \.number) { level in
                            LevelButton(level: level) {
                                selectedLevel = level
                                showGame = true
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .fullScreenCover(isPresented: $showGame) {
            if let level = selectedLevel {
                GameViewA(level: level)
            }
        }
    }
}

struct LevelButton: View {
    let level: Level
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            if level.isUnlocked {
                action()
            }
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(level.isUnlocked ? CandyTheme.levelButtonGradient : CandyTheme.grayGradient)
                        .frame(width: 80, height: 80)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    
                    if level.isUnlocked {
                        Text("\(level.number)")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                
                // Stars
//                if level.isUnlocked && level.bestStars > 0 {
//                    HStack(spacing: 2) {
//                        ForEach(0..<3) { index in
//                            Image(systemName: index < level.bestStars ? "star.fill" : "star")
//                                .font(.caption)
//                                .foregroundColor(index < level.bestStars ? Color(hex: "FFD700") : .gray)
//                        }
//                    }
//                }
            }
        }
        .disabled(!level.isUnlocked)
        .scaleEffect(level.isUnlocked ? 1.0 : 0.9)
        .opacity(level.isUnlocked ? 1.0 : 0.6)
    }
}

#Preview {
    MapLevelViewA()
}
