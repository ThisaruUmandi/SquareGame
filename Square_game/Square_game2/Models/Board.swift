import Foundation

struct Position: Hashable, Equatable {
    let row: Int
    let col: Int
    
    func isAdjacent(to other: Position) -> Bool {
        let rowDiff = abs(self.row - other.row)
        let colDiff = abs(self.col - other.col)
        return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1)
    }
}

class Board: ObservableObject {
    @Published var tiles: [[Tile]]
    let rows: Int
    let cols: Int
    
    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        self.tiles = Array(repeating: Array(repeating: Tile(), count: cols), count: rows)
    }
    
    func getTile(at position: Position) -> Tile? {
        guard isValid(position: position) else { return nil }
        return tiles[position.row][position.col]
    }
    
    func setTile(at position: Position, tile: Tile) {
        guard isValid(position: position) else { return }
        
        // CRITICAL: Directly modify the published array to trigger UI updates
        tiles[position.row][position.col] = tile
        
        // Force publish update
        objectWillChange.send()
    }
    
    func isValid(position: Position) -> Bool {
        return position.row >= 0 && position.row < rows &&
               position.col >= 0 && position.col < cols
    }
    
    func swap(_ pos1: Position, _ pos2: Position) {
        guard isValid(position: pos1) && isValid(position: pos2) else { return }
        
        // CRITICAL: Swap the actual candy objects, not the entire tiles
        let candy1 = tiles[pos1.row][pos1.col].candy
        let candy2 = tiles[pos2.row][pos2.col].candy
        
        tiles[pos1.row][pos1.col].candy = candy2
        tiles[pos2.row][pos2.col].candy = candy1
        
        // Force publish update
        objectWillChange.send()
    }
}
