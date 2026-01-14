import SwiftUI

struct ContentView: View {

    let colors: [Color] = [.red, .yellow, .green]
    let size = 3

    @State private var grid: [[Color]] = [
        [.red, .yellow, .green],
        [.green, .red, .yellow],
        [.yellow, .green, .red]
    ]

    @State private var selectedRow: Int? = nil
    @State private var selectedCol: Int? = nil
    @State private var showWin = false

    var body: some View {
        VStack(spacing: 20) {

            Text("Square Game")
                .font(.largeTitle)
                .bold()

            VStack(spacing: 8) {
                ForEach(0..<size, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(0..<size, id: \.self) { col in
                            Rectangle()
                                .fill(grid[row][col])
                                .frame(width: 90, height: 90)
                                .cornerRadius(10)
                                .overlay(
                                    selectedRow == row && selectedCol == col
                                    ? RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 3)
                                    : nil
                                )
                                .onTapGesture {
                                    handleTap(row: row, col: col)
                                }
                        }
                    }
                }
            }
        }
        .padding()
        .alert("You Win!", isPresented: $showWin) {
            Button("OK") {}
        }
    }

    // MARK: - Logic

    func handleTap(row: Int, col: Int) {
        if selectedRow == nil {
            selectedRow = row
            selectedCol = col
            return
        }

        let r = selectedRow!
        let c = selectedCol!

        let isAdjacent =
            (abs(r - row) == 1 && c == col) ||
            (abs(c - col) == 1 && r == row)

        if isAdjacent {
            swap(r, c, row, col)
            checkWin()
        }

        selectedRow = nil
        selectedCol = nil
    }

    func swap(_ r1: Int, _ c1: Int, _ r2: Int, _ c2: Int) {
        let temp = grid[r1][c1]
        grid[r1][c1] = grid[r2][c2]
        grid[r2][c2] = temp
    }

    func checkWin() {
        var redLine = false
        var yellowLine = false
        var greenLine = false

        // Check rows
        for r in 0..<size {
            let row = grid[r]
            if row.allSatisfy({ $0 == .red }) {
                redLine = true
            }
            if row.allSatisfy({ $0 == .yellow }) {
                yellowLine = true
            }
            if row.allSatisfy({ $0 == .green }) {
                greenLine = true
            }
        }

        // Check columns
        for c in 0..<size {
            let col = [grid[0][c], grid[1][c], grid[2][c]]
            if col.allSatisfy({ $0 == .red }) {
                redLine = true
            }
            if col.allSatisfy({ $0 == .yellow }) {
                yellowLine = true
            }
            if col.allSatisfy({ $0 == .green }) {
                greenLine = true
            }
        }

        if redLine && yellowLine && greenLine {
            showWin = true
        }
    }

}

#Preview {
    ContentView()
}
