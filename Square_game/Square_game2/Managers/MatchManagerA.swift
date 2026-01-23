import Foundation

class MatchManagerA {
    func findMatches(in board: Board) -> [Match] {
        var matches: [Match] = []
        var processedPositions: Set<Position> = []
        
        // Find horizontal matches
        for row in 0..<board.rows {
            var currentStreak: [Position] = []
            var currentType: CandyType?
            
            for col in 0..<board.cols {
                let pos = Position(row: row, col: col)
                guard let tile = board.getTile(at: pos),
                      let candy = tile.candy,
                      tile.isMovable else {
                    if currentStreak.count >= 3 {
                        let match = createMatch(from: currentStreak, type: currentType!)
                        matches.append(match)
                        processedPositions.formUnion(currentStreak)
                    }
                    currentStreak = []
                    currentType = nil
                    continue
                }
                
                if currentType == candy.type {
                    currentStreak.append(pos)
                } else {
                    if currentStreak.count >= 3 {
                        let match = createMatch(from: currentStreak, type: currentType!)
                        matches.append(match)
                        processedPositions.formUnion(currentStreak)
                    }
                    currentStreak = [pos]
                    currentType = candy.type
                }
            }
            
            if currentStreak.count >= 3 {
                let match = createMatch(from: currentStreak, type: currentType!)
                matches.append(match)
                processedPositions.formUnion(currentStreak)
            }
        }
        
        // Find vertical matches
        for col in 0..<board.cols {
            var currentStreak: [Position] = []
            var currentType: CandyType?
            
            for row in 0..<board.rows {
                let pos = Position(row: row, col: col)
                guard let tile = board.getTile(at: pos),
                      let candy = tile.candy,
                      tile.isMovable else {
                    if currentStreak.count >= 3 {
                        let match = createMatch(from: currentStreak, type: currentType!)
                        if !processedPositions.isSuperset(of: currentStreak) {
                            matches.append(match)
                        }
                    }
                    currentStreak = []
                    currentType = nil
                    continue
                }
                
                if currentType == candy.type {
                    currentStreak.append(pos)
                } else {
                    if currentStreak.count >= 3 {
                        let match = createMatch(from: currentStreak, type: currentType!)
                        if !processedPositions.isSuperset(of: currentStreak) {
                            matches.append(match)
                        }
                    }
                    currentStreak = [pos]
                    currentType = candy.type
                }
            }
            
            if currentStreak.count >= 3 {
                let match = createMatch(from: currentStreak, type: currentType!)
                if !processedPositions.isSuperset(of: currentStreak) {
                    matches.append(match)
                }
            }
        }
        
        return matches
    }
    
    private func createMatch(from positions: [Position], type: CandyType) -> Match {
        let matchType: MatchType
        if positions.count >= 5 {
            matchType = .five
        } else if positions.count == 4 {
            matchType = .four
        } else {
            matchType = .three
        }
        
        return Match(positions: Set(positions), type: matchType, candyType: type)
    }
    
    func hasValidMove(in board: Board) -> Bool {
        for row in 0..<board.rows {
            for col in 0..<board.cols {
                let pos = Position(row: row, col: col)
                
                // Check right swap
                if col < board.cols - 1 {
                    let rightPos = Position(row: row, col: col + 1)
                    if wouldCreateMatch(board: board, swapping: pos, with: rightPos) {
                        return true
                    }
                }
                
                // Check down swap
                if row < board.rows - 1 {
                    let downPos = Position(row: row + 1, col: col)
                    if wouldCreateMatch(board: board, swapping: pos, with: downPos) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func wouldCreateMatch(board: Board, swapping pos1: Position, with pos2: Position) -> Bool {
        guard let tile1 = board.getTile(at: pos1),
              let tile2 = board.getTile(at: pos2),
              tile1.isMovable && tile2.isMovable else {
            return false
        }
        
        // Simulate swap
        var tempBoard = board
        tempBoard.swap(pos1, pos2)
        
        // Check for matches
        let matches = findMatches(in: tempBoard)
        return !matches.isEmpty
    }
}
