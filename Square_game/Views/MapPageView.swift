//import SwiftUI
//
//struct MapPageView: View {
//    @EnvironmentObject var gameManager: GameManager
//    @EnvironmentObject var highScoreManager: HighScoreManager
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Level Map").font(.largeTitle).bold()
//            Text("Current Round: \(gameManager.leve')")
//            Text("Grid Size: \(gameManager.gridSize)x\(gameManager.gridSize)")
//
//            NavigationLink("Play") {
//                GameView()
//                    .environmentObject(gameManager)
//                    .environmentObject(highScoreManager)
//            }
//        }
//    }
//}
