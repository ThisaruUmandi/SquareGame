import Foundation

class GravityManagerA {
    
    func applyGravity(to board: Board, candyTypes: Int) -> Bool {
        var didMove = false
        
        // Process each column from bottom to top
        for col in 0..<board.cols {
            // Compact existing candies downward
            var writeRow = board.rows - 1
            
            // First pass: move all existing candies down
            for row in stride(from: board.rows - 1, through: 0, by: -1) {
                let pos = Position(row: row, col: col)
                guard let tile = board.getTile(at: pos) else { continue }
                
                // Skip blocked tiles
                if tile.state.isBlocked {
                    writeRow = row - 1
                    continue
                }
                
                // If tile has a candy and isn't matched, move it down
                if let candy = tile.candy, !tile.isMatched {
                    if row != writeRow {
                        // Move candy to writeRow
                        var newTile = board.getTile(at: Position(row: writeRow, col: col))!
                        newTile.candy = candy
                        board.setTile(at: Position(row: writeRow, col: col), tile: newTile)
                        
                        // Clear old position
                        var oldTile = tile
                        oldTile.candy = nil
                        board.setTile(at: pos, tile: oldTile)
                        
                        didMove = true
                    }
                    writeRow -= 1
                }
            }
            
            // Second pass: fill empty spaces from top with new candies
            for row in 0..<board.rows {
                let pos = Position(row: row, col: col)
                guard var tile = board.getTile(at: pos) else { continue }
                
                // Fill if empty and not blocked
                if tile.candy == nil && !tile.state.isBlocked {
                    tile.candy = CandyFactory.createRandomCandy(availableTypes: candyTypes)
                    board.setTile(at: pos, tile: tile)
                    didMove = true
                }
            }
        }
        
        return didMove
    }
    
    // MARK: - Match Clearing
    
    func clearMatches(matches: [Match], from board: Board) {
        for match in matches {
            for position in match.positions {
                guard var tile = board.getTile(at: position) else { continue }
                
                // Clear the candy
                tile.candy = nil
                tile.isMatched = true
                
                // Reduce obstacle layers if present
                if tile.hasObstacle {
                    tile.reduceObstacle()
                }
                
                board.setTile(at: position, tile: tile)
            }
        }
    }
    
    func resetMatchedFlags(in board: Board) {
        for row in 0..<board.rows {
            for col in 0..<board.cols {
                let pos = Position(row: row, col: col)
                guard var tile = board.getTile(at: pos) else { continue }
                tile.isMatched = false
                board.setTile(at: pos, tile: tile)
            }
        }
    }
}
