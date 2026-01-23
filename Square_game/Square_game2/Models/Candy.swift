import SwiftUI

enum CandyType: Int, CaseIterable {
    case red = 0
    case orange = 1
    case yellow = 2
    case green = 3
    case blue = 4
    case purple = 5
    case pink = 6
    
    var color: Color {
        switch self {
        case .red: return Color(hex: "FF0080")
        case .orange: return Color(hex: "FF8C00")
        case .yellow: return Color(hex: "FFD700")
        case .green: return Color(hex: "00FF7F")
        case .blue: return Color(hex: "1E90FF")
        case .purple: return Color(hex: "9370DB")
        case .pink: return Color(hex: "FF69B4")
        }
    }
    
    var emoji: String {
        switch self {
        case .red: return "🍓"
        case .orange: return "🍊"
        case .yellow: return "🍋"
        case .green: return "🍏"
        case .blue: return "🫐"
        case .purple: return "🍇"
        case .pink: return "🍑"
        }
    }
}

enum SpecialCandyType {
    case none
    case striped(direction: StripeDirection)
    case bomb
    case colorBomb
}

enum StripeDirection {
    case horizontal
    case vertical
}

struct Candy: Identifiable, Equatable {
    let id = UUID()
    var type: CandyType
    var specialType: SpecialCandyType = .none
    
    static func == (lhs: Candy, rhs: Candy) -> Bool {
        return lhs.id == rhs.id
    }
    
    func matches(_ other: Candy) -> Bool {
        return self.type == other.type
    }
}
