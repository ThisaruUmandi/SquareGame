import SwiftUI

struct Grid {
    // Generate a solvable grid with fix for uneven color distribution
    static func generate(size: Int, colorCount: Int) -> [[ColorTile]] {
        var tiles: [ColorTile] = []
        let colors = generateRandomColors(count: colorCount)
        
        let totalTiles = size * size
        let tilesPerColor = totalTiles / colorCount
        let remainder = totalTiles % colorCount
        
        // 1. Create tiles with equal distribution
        for colorIndex in 0..<colorCount {
            for _ in 0..<tilesPerColor {
                tiles.append(ColorTile(
                    color: colors[colorIndex],
                    position: GridPosition(row: 0, col: 0) // Temp position
                ))
            }
        }
        
        // 2. Fill the remainder slots with random colors from the set
        for _ in 0..<remainder {
            if let randomColor = colors.randomElement() {
                tiles.append(ColorTile(
                    color: randomColor,
                    position: GridPosition(row: 0, col: 0)
                ))
            }
        }
        
        // 3. Shuffle tiles but keep positions
        tiles.shuffle()
        
        // 4. Create the 2D grid and assign actual positions
        var grid: [[ColorTile]] = []
        for row in 0..<size {
            var rowTiles: [ColorTile] = []
            for col in 0..<size {
                let index = row * size + col
                var tile = tiles[index]
                tile.position = GridPosition(row: row, col: col)
                rowTiles.append(tile)
            }
            grid.append(rowTiles)
        }
        
        return grid
    }
    
    private static func generateRandomColors(count: Int) -> [Color] {
        var colors: [Color] = []
        let hueStep = 1.0 / Double(count)
        
        for i in 0..<count {
            let hue = Double(i) * hueStep
            colors.append(Color(hue: hue, saturation: 0.8, brightness: 0.9))
        }
        
        return colors.shuffled()
    }
    
    static func isSolved(_ grid: [[ColorTile]]) -> Bool {
        return isHorizontallySolved(grid) || isVerticallySolved(grid)
    }
    
    private static func isHorizontallySolved(_ grid: [[ColorTile]]) -> Bool {
        for row in grid {
            guard let firstColor = row.first?.color else { continue }
            if !row.allSatisfy({ $0.color == firstColor }) {
                return false
            }
        }
        return true
    }
    
    private static func isVerticallySolved(_ grid: [[ColorTile]]) -> Bool {
        let size = grid.count
        guard size > 0 else { return false }
        
        for col in 0..<size {
            let firstColor = grid[0][col].color
            for row in 1..<size {
                if grid[row][col].color != firstColor {
                    return false
                }
            }
        }
        return true
    }
    
    static func swap(in grid: inout [[ColorTile]], from: GridPosition, to: GridPosition) -> Bool {
        let rowDiff = abs(from.row - to.row)
        let colDiff = abs(from.col - to.col)
        
        // Ensure adjacency (horizontal or vertical, not diagonal)
        guard (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1) else {
            return false
        }
        
        // Swap color properties between the two grid coordinates
        let tempColor = grid[from.row][from.col].color
        grid[from.row][from.col].color = grid[to.row][to.col].color
        grid[to.row][to.col].color = tempColor
        
        return true
    }
}
