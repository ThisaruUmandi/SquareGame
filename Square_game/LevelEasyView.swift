import SwiftUI

struct LevelEasyView: View {
    
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
    @State private var moves = 0
    @State private var animatingCell: (Int, Int)? = nil
    
    var body: some View {
        ZStack {
            // Gradient background
//            LinearGradient(
//                colors: [Color.green.opacity(0.2), Color.blue.opacity(0.2)],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
            
            // Gradient background
            LinearGradient(
                colors: [/*Color.red.opacity(0.6),*/
                         /*Color.orange.opacity(0.3),*/
                         Color.yellow.opacity(0.3),
                         Color.green.opacity(0.3),
                         Color.blue.opacity(0.3),
                         Color.purple.opacity(0.3),
                         Color.pink.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // Header
                VStack(spacing: 8) {
                    Text("Easy Level")
                        .font(.system(size: 36, weight: .bold))
                    
                    HStack(spacing: 20) {
                        HStack {
                            Image(systemName: "arrow.left.arrow.right")
                                .foregroundColor(.blue)
                            Text("Moves: \(moves)")
                                .font(.headline)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                        )
                    }
                }
                .padding(.top, 20)
                
                // Instructions
                Text("Match each color in a row or column")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                // Game Grid
                VStack(spacing: 12) {
                    ForEach(0..<size, id: \.self) { row in
                        HStack(spacing: 12) {
                            ForEach(0..<size, id: \.self) { col in
                                GameCell(
                                    color: grid[row][col],
                                    isSelected: selectedRow == row && selectedCol == col,
                                    isAnimating: animatingCell?.0 == row && animatingCell?.1 == col
                                )
                                .onTapGesture {
                                    handleTap(row: row, col: col)
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 15)
                )
                .padding(.horizontal, 30)
                
                Spacer()
                
                // Reset button
//                Button(action: resetGame) {
//                    HStack {
//                        Image(systemName: "arrow.clockwise")
//                        Text("Reset")
//                    }
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 30)
//                    .padding(.vertical, 12)
//                    .background(
//                        Capsule()
//                            .fill(Color.blue)
//                    )
//                    .shadow(radius: 5)
//                }
                .padding(.bottom, 20)
            }
        }
        .alert("You Win!", isPresented: $showWin) {
//            Button("Play Again") {
//                resetGame()
//            }
            Button("OK") {}
        } message: {
            Text("Completed in \(moves) moves!")
        }
    }
    
    func resetGame() {
        grid = [
            [.red, .yellow, .green],
            [.green, .red, .yellow],
            [.yellow, .green, .red]
        ]
        moves = 0
        selectedRow = nil
        selectedCol = nil
    }
    
    func handleTap(row: Int, col: Int) {
        withAnimation(.spring(response: 0.3)) {
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
                animatingCell = (row, col)
                swap(r, c, row, col)
                moves += 1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    animatingCell = nil
                    checkWin()
                }
            }
            
            selectedRow = nil
            selectedCol = nil
        }
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
        
        // Check horizontally
        for r in 0..<size {
            let row = grid[r]
            if row.allSatisfy({ $0 == .red }) { redLine = true }
            if row.allSatisfy({ $0 == .yellow }) { yellowLine = true }
            if row.allSatisfy({ $0 == .green }) { greenLine = true }
        }
        
        // Check vertically
        for c in 0..<size {
            let col = [grid[0][c], grid[1][c], grid[2][c]]
            if col.allSatisfy({ $0 == .red }) { redLine = true }
            if col.allSatisfy({ $0 == .yellow }) { yellowLine = true }
            if col.allSatisfy({ $0 == .green }) { greenLine = true }
        }
        
        if redLine && yellowLine && greenLine {
            withAnimation {
                showWin = true
            }
        }
    }
}

struct GameCell: View {
    let color: Color
    let isSelected: Bool
    let isAnimating: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(color)
            .frame(width: 90, height: 90)
            .shadow(color: color.opacity(0.6), radius: isSelected ? 8 : 4, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(.spring(response: 0.3), value: isSelected)
            .animation(.easeInOut(duration: 0.3), value: isAnimating)
    }
}

#Preview {
    LevelEasyView()
}
