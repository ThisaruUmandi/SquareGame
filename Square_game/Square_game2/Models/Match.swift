import Foundation

enum MatchType {
    case three
    case four
    case five
    case lShape
    case tShape
}

struct Match {
    let positions: Set<Position>
    let type: MatchType
    let candyType: CandyType
    
    var count: Int {
        return positions.count
    }
    
    var score: Int {
        switch type {
        case .three: return 60
        case .four: return 120
        case .five: return 200
        case .lShape: return 300
        case .tShape: return 300
        }
    }
}
