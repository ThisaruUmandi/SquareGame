import Foundation

class CandyFactory {
    static func createRandomCandy(availableTypes: Int) -> Candy {
        let maxType = min(availableTypes - 1, CandyType.allCases.count - 1)
        let randomIndex = Int.random(in: 0...maxType)
        let candyType = CandyType(rawValue: randomIndex) ?? .red
        return Candy(type: candyType)
    }
    
    static func createCandy(type: CandyType) -> Candy {
        return Candy(type: type)
    }
    
    static func createSpecialCandy(type: CandyType, special: SpecialCandyType) -> Candy {
        return Candy(type: type, specialType: special)
    }
}
