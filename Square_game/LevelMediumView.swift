import SwiftUI

struct LevelMediumView: View {

    let colors: [Color] = [.red, .yellow, .green, .blue, .orange]
    let size = 5

    @State private var grid: [[Color]] = [
        [.red, .yellow, .green, .blue, .orange],
        [.orange, .red, .yellow, .green, .blue],
        [.blue, .orange, .red, .yellow, .green],
        [.green, .blue, .orange, .red, .yellow],
        [.yellow, .green, .blue, .orange, .red]
    ]


    @State private var selectedRow: Int? = nil
    @State private var selectedCol: Int? = nil
    @State private var showWin = false

    var body: some View {
        VStack(spacing: 40) {

            Text("Level Medium")
                .font(.largeTitle)
                .bold()

            VStack(spacing: 8) {
                ForEach(0..<size, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(0..<size, id: \.self) { col in
                            Rectangle()
                                .fill(grid[row][col])
                                .frame(width: 60, height: 60)
                                .cornerRadius(10)
                                .overlay(
                                    selectedRow == row && selectedCol == col
                                    ? RoundedRectangle(cornerRadius: 10)
                                        .stroke(.secondary, lineWidth: 5)
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

    // Logics

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
        var blueLine = false
        var orangeLine = false
        

        // Check horizontally, row wise
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
            if row.allSatisfy({ $0 == .blue }) {
                blueLine = true
            }
            if row.allSatisfy({ $0 == .orange }) {
                orangeLine = true
            }
        }

        // Check vertically, column wise
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
            if col.allSatisfy({ $0 == .blue }) {
                blueLine = true
            }
            if col.allSatisfy({ $0 == .orange }) {
                orangeLine = true
            }
        }

        if redLine && yellowLine && greenLine && blueLine && orangeLine {
            showWin = true
        }
    }

}

#Preview {
    LevelMediumView()
}
