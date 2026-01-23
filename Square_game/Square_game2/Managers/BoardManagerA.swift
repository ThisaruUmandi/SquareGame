import Foundation

class BoardManagerA: ObservableObject {
    @Published var board: Board
    private let candyTypes: Int
    
    init(size: Int, candyTypes: Int) {
        self.board = Board(rows: size, cols: size)
        self.candyTypes = candyTypes
        initializeBoard()
    }
    
    // MARK: - Board Setup
    
    func initializeBoard() {
        for row in 0..<board.rows {
            for col in 0..<board.cols {
                var tile = Tile()
                tile.candy = CandyFactory.createRandomCandy(availableTypes: candyTypes)
                board.setTile(at: Position(row: row, col: col), tile: tile)
            }
        }
        
        removeInitialMatches()
    }
    
    private func removeInitialMatches() {
        let matchManager = MatchManagerA()
        var matches = matchManager.findMatches(in: board)
        
        while !matches.isEmpty {
            for match in matches {
                for position in match.positions {
                    var tile = board.getTile(at: position)!
                    tile.candy = CandyFactory.createRandomCandy(availableTypes: candyTypes)
                    board.setTile(at: position, tile: tile)
                }
            }
            matches = matchManager.findMatches(in: board)
        }
    }
    
    // MARK: - Obstacles
    
    func setupObstacles(hasJelly: Bool, hasIce: Bool, hasBlockers: Bool) {
        if hasJelly { addJellyTiles() }
        if hasIce { addIceTiles() }
        if hasBlockers { addBlockers() }
    }
    
    private func addJellyTiles() {
        let jellyCount = board.rows * board.cols / 4
        var added = 0
        
        while added < jellyCount {
            let pos = Position(
                row: Int.random(in: 0..<board.rows),
                col: Int.random(in: 0..<board.cols)
            )
            
            if var tile = board.getTile(at: pos),
               tile.state.isNormal {
                
                tile.state = .jelly(layers: Bool.random() ? 1 : 2)
                board.setTile(at: pos, tile: tile)
                added += 1
            }
        }
    }
    
    private func addIceTiles() {
        let iceCount = board.rows * board.cols / 6
        var added = 0
        
        while added < iceCount {
            let pos = Position(
                row: Int.random(in: 0..<board.rows),
                col: Int.random(in: 0..<board.cols)
            )
            
            if var tile = board.getTile(at: pos),
               tile.state.isNormal {
                
                tile.state = .ice(layers: 1)
                board.setTile(at: pos, tile: tile)
                added += 1
            }
        }
    }
    
    private func addBlockers() {
        let blockerCount = board.rows * board.cols / 10
        var added = 0
        
        while added < blockerCount {
            let pos = Position(
                row: Int.random(in: 0..<board.rows),
                col: Int.random(in: 0..<board.cols)
            )
            
            if var tile = board.getTile(at: pos),
               tile.state.isNormal {
                
                tile.state = .blocked
                tile.candy = nil
                board.setTile(at: pos, tile: tile)
                added += 1
            }
        }
    }
    
    // MARK: - Swapping
    
    func canSwap(_ pos1: Position, _ pos2: Position) -> Bool {
        guard let tile1 = board.getTile(at: pos1),
              let tile2 = board.getTile(at: pos2) else {
            return false
        }
        
        return tile1.isMovable &&
               tile2.isMovable &&
               pos1.isAdjacent(to: pos2)
    }
    
    func swap(_ pos1: Position, _ pos2: Position) {
        board.swap(pos1, pos2)
    }
}
