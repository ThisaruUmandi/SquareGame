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
            // Candy Theme Background
            CandyTheme.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("🏆 New High Score!")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 4)
                
                VStack(spacing: 10) {
                    Text("Round \(round)")
                        .font(.system(.title2, design: .rounded).bold())
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("Score: \(score)")
                        .font(.system(size: 44, weight: .black, design: .rounded))
                        .foregroundStyle(CandyTheme.primaryGradient)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(20)
                }
                
                VStack(alignment: .center, spacing: 15) {
                    Text("Enter Your Name")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.white)
                    
                    TextField("Player Name", text: $playerName)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .focused($isNameFieldFocused)
                        .submitLabel(.done)
                        .onSubmit { saveScore() }
                }
                .padding(.horizontal, 40)
                
                Button(action: saveScore) {
                    Text("SAVE")
                }
                .buttonStyle(PuffyButtonStyle(
                    color: playerName.trimmingCharacters(in: .whitespaces).isEmpty ?
                           CandyTheme.grayGradient : CandyTheme.successGradient
                ))
                .disabled(playerName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .modifier(CandyCard()) // Applies the puffy white card with pink border
            .padding(20)
        }
        .interactiveDismissDisabled()
        .onAppear {
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

