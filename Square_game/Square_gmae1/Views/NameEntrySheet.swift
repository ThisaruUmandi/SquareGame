import SwiftUI

struct NameEntrySheet: View {
    let score: Int
    let round: Int
    let onSave: (String) -> Void
    
    @State private var playerName: String = ""
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        ZStack {
            // MARK: - Mobile Background
            CandyTheme.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Header - Scaled for Mobile
//                Text("🏆")
//                    .font(.system(size: 48, weight: .black, design: .rounded))
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
//                    .shadow(color: .black.opacity(0.2), radius: 4, y: 4)
//                    .padding(.top, 20)
                Text("New High Score!")
                    .font(.system(size: 35, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.2), radius: 4, y: 4)
                    .padding(.top, 20)
                
                // Score Display Card
                VStack(spacing: 8) {
                    Text("ROUND \(round)")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(score)")
                        .font(.system(size: 60, weight: .black, design: .rounded))
                        .foregroundColor(.yellow)
                        .shadow(color: .orange.opacity(0.5), radius: 0, x: 0, y: 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white.opacity(0.15))
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.3), lineWidth: 3))
                )
                .padding(.horizontal, 30)
                .padding(50)
                
                // Input Section
                VStack(alignment: .center, spacing: 12) {
                    Text("ENTER YOUR NAME")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    TextField("Player Name", text: $playerName)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 15)
                        .background(Color.white)
                        .cornerRadius(18)
                        .foregroundColor(.black)
                        .focused($isNameFieldFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            saveScore()
                        }
                }
                .padding(.horizontal, 40)
                
                // Save Button - Puffy Style
                Button(action: saveScore) {
                    Text("SAVE SCORE")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            playerName.trimmingCharacters(in: .whitespaces).isEmpty ?
                            AnyShapeStyle(Color.pink.opacity(0.8)) : AnyShapeStyle(CandyTheme.primaryGradient)
                        )
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 6)
                }
                .padding(.horizontal, 40)
                .disabled(playerName.trimmingCharacters(in: .whitespaces).isEmpty)
                
                Spacer()
            }
            .padding(.top, 40)
        }
        .interactiveDismissDisabled()
        .onAppear {
            // Auto-focus keyboard on mobile appear
            isNameFieldFocused = true
        }
    }
    
    private func saveScore() {
        let trimmedName = playerName.trimmingCharacters(in: .whitespaces)
        if !trimmedName.isEmpty {
            onSave(trimmedName)
            dismiss()
        }
    }
}

#Preview("Name Entry") {
    NameEntrySheet(
        score: 450,
        round: 5,
        onSave: { _ in }
    )
}
