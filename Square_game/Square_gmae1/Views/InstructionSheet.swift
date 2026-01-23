import SwiftUI

struct InstructionsSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            CandyTheme.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 25) {
                Text("How to Play")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .pink, radius: 5, x: 0, y: 0)
                
                VStack(spacing: 20) {
                    instructionRow(icon: "hand.draw.fill", text: "Tap two adjacent tiles to swap their colors.")
                    instructionRow(icon: "paintpalette.fill", text: "Match the pattern shown in the goal to win.")
                    instructionRow(icon: "timer", text: "Watch the clock! Clear the level before time runs out.")
                    instructionRow(icon: "star.fill", text: "Fewer moves + more time = Higher Score! 🏆")
                }
                .padding(.vertical)
                
                // Animated Hint Demo
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 120)
                    
                    HStack(spacing: 20) {
                        demoTile(color: .pink)
                        Image(systemName: "arrow.left.and.right")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        demoTile(color: .blue)
                    }
                    
                    // Moving finger animation
                    Image(systemName: "hand.tap.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 10, x: 0, y: 0)
                        .offset(x: -40)
                        .phaseAnimator([0, 80]) { content, phase in
                            content.offset(x: phase)
                        } animation: { _ in
                            .easeInOut(duration: 1.5).repeatForever(autoreverses: true)
                        }
                }
                
                Button("GOT IT!") {
                    dismiss()
                }
                .buttonStyle(PuffyButtonStyle(color: CandyTheme.successGradient))
            }
            .modifier(CandyCard())
            .padding(30)
        }
    }
    
    private func instructionRow(icon: String, text: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2.bold())
                .foregroundColor(Color(hex: "FF6BBD"))
                .frame(width: 40)
            
            Text(text)
                .font(.system(.body, design: .rounded).weight(.bold))
                .foregroundColor(.black.opacity(0.7))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
    
    private func demoTile(color: Color) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(color)
            .frame(width: 50, height: 50)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 2))
    }
}
#Preview {
    InstructionsSheet()
}
