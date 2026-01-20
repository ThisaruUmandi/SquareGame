import SwiftUI

struct InitialPageView: View {
    @EnvironmentObject var levelManager: LevelManager
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        VStack(spacing: 40) {
            Text("Color Sorter")
                .font(.system(size: 48, weight: .bold))
            Button {
                gameManager.startLevel()
            } label: {
                Text("Start Game")
                    .font(.title2)
                    .padding()
                    .background(Capsule().fill(Color.blue))
                    .foregroundColor(.white)
            }
            NavigationLink(destination: HighScoreView()) {
                Text("High Scores")
            }
        }
    }
}

struct InitialPageView_Previews: PreviewProvider {
    static var previews: some View {
        InitialPageView()
            .environmentObject(LevelManager())
            .environmentObject(GameManager(levelManager: LevelManager()))
    }
}
