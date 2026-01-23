// Tile.swift

import Foundation

enum TileState {
    case normal
    case jelly(layers: Int)
    case ice(layers: Int)
    case blocked
    case locked
}

// ✅ THIS WAS MISSING
extension TileState {
    var isNormal: Bool {
        if case .normal = self { return true }
        return false
    }
    
    var isBlocked: Bool {
        if case .blocked = self { return true }
        return false
    }
}

struct Tile: Identifiable {
    let id = UUID()
    var candy: Candy?
    var state: TileState = .normal
    var isMatched: Bool = false
    
    var isMovable: Bool {
        switch state {
        case .blocked, .locked:
            return false
        default:
            return true
        }
    }
    
    var hasObstacle: Bool {
        switch state {
        case .jelly, .ice:
            return true
        default:
            return false
        }
    }
    
    mutating func reduceObstacle() {
        switch state {
        case .jelly(let layers) where layers > 1:
            state = .jelly(layers: layers - 1)
        case .jelly:
            state = .normal
        case .ice(let layers) where layers > 1:
            state = .ice(layers: layers - 1)
        case .ice:
            state = .normal
        default:
            break
        }
    }
}
