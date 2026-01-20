import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameManager: GameManager

    @State private var selectedRow: Int? = nil
    @State private var selectedCol: Int? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Round \(gameManager.levelManager.round)").font(.title)
            HStack(spacing: 20) {
                Label("\(gameManager.moves)/\(gameManager.maxMoves)", systemImage: "arrow.left.arrow.right")
                Label("\(gameManager.timeRemaining)s", systemImage: "clock")
                Label("\(gameManager.score)", systemImage: "star.fill")
            }

            VStack(spacing: 8) {
                ForEach(0..<gameManager.grid.count, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(0..<gameManager.grid.count, id: \.self) { col in
                            Rectangle()
                                .fill(gameManager.grid[row][col])
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedRow == row && selectedCol == col ? Color.white : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture {
                                    handleTap(row: row, col: col)
                                }
                        }
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $gameManager.showGameOverSheet) {
            GameOverSheet()
                .environmentObject(gameManager)
        }
    }

    func handleTap(row: Int, col: Int) {
        if selectedRow == nil {
            selectedRow = row
            selectedCol = col
            return
        }

        let r = selectedRow!
        let c = selectedCol!

        let isAdjacent = (abs(r-row) == 1 && c == col) || (abs(c-col) == 1 && r == row)
        if isAdjacent {
            gameManager.swapTiles(r1: r, c1: c, r2: row, c2: col)
        }

        selectedRow = nil
        selectedCol = nil
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameManager(levelManager: LevelManager()))
    }
}
