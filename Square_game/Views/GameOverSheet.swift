import SwiftUI

struct GameOverSheet: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var playerName: String = ""

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: gameManager.didWin ? "checkmark.circle.fill" : "xmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(gameManager.didWin ? .green : .red)

            Text(gameManager.didWin ? "You Won!" : "Game Over")
                .font(.largeTitle)
                .bold()

            Text("Score: \(gameManager.score)")

            if gameManager.didWin {
                Button("Next Level") {
                    gameManager.nextLevel()
                }
                .padding()
                .background(Capsule().fill(Color.green))
                .foregroundColor(.white)
            } else {
                Button("Restart Level") {
                    gameManager.restartLevel()
                }
                .padding()
                .background(Capsule().fill(Color.red))
                .foregroundColor(.white)
            }
        }
        .padding()
    }
}

struct GameOverSheet_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GameOverSheet()
                .environmentObject(LevelManager())
        }
    }
}

