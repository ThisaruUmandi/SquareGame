import Foundation

class GridA {
    static func allPositions(rows: Int, cols: Int) -> [Position] {
        var positions: [Position] = []
        for row in 0..<rows {
            for col in 0..<cols {
                positions.append(Position(row: row, col: col))
            }
        }
        return positions
    }
    
    static func neighbors(of position: Position, rows: Int, cols: Int) -> [Position] {
        var neighbors: [Position] = []
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
        
        for (dr, dc) in directions {
            let newRow = position.row + dr
            let newCol = position.col + dc
            if newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols {
                neighbors.append(Position(row: newRow, col: newCol))
            }
        }
        
        return neighbors
    }
    
    static func positionsInRadius(center: Position, radius: Int, rows: Int, cols: Int) -> [Position] {
        var positions: [Position] = []
        
        for row in max(0, center.row - radius)...min(rows - 1, center.row + radius) {
            for col in max(0, center.col - radius)...min(cols - 1, center.col + radius) {
                positions.append(Position(row: row, col: col))
            }
        }
        
        return positions
    }
}
