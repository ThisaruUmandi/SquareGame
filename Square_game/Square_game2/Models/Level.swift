import Foundation

enum LevelObjective {
    case reachScore
    case clearJelly
    case clearSpecificCandies(type: CandyType, count: Int)
}

struct Level {
    let number: Int
    let boardSize: Int
    let candyTypes: Int
    let movesAllowed: Int
    let timeAllowed: Int
    let targetScore: Int
    let objective: LevelObjective
    let hasJelly: Bool
    let hasIce: Bool
    let hasBlockers: Bool
    
    var isUnlocked: Bool {
        return number <= UserDefaults.standard.integer(forKey: "maxUnlockedLevel")
    }
    
    var bestStars: Int {
        return UserDefaults.standard.integer(forKey: "level_\(number)_stars")
    }
    
    func saveStars(_ stars: Int) {
        let current = bestStars
        if stars > current {
            UserDefaults.standard.set(stars, forKey: "level_\(number)_stars")
            if number == UserDefaults.standard.integer(forKey: "maxUnlockedLevel") {
                UserDefaults.standard.set(number + 1, forKey: "maxUnlockedLevel")
            }
        }
    }
    
    static func resetProgress() {
        UserDefaults.standard.set(1, forKey: "maxUnlockedLevel")
        for i in 1...50 {
            UserDefaults.standard.removeObject(forKey: "level_\(i)_stars")
        }
    }
}
