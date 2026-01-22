import SwiftUI

struct ColorTile: Identifiable, Equatable {
    let id = UUID()
    var color: Color
    var position: GridPosition
    
    static func == (lhs: ColorTile, rhs: ColorTile) -> Bool {
        lhs.id == rhs.id
    }
}

struct GridPosition: Equatable {
    let row: Int
    let col: Int
}
