import Foundation

class LevelManagerA: ObservableObject {
    @Published var levels: [Level] = []
    
    init() {
        generateLevels()
        initializeProgress()
    }
    
    private func initializeProgress() {
        if UserDefaults.standard.integer(forKey: "maxUnlockedLevel") == 0 {
            UserDefaults.standard.set(1, forKey: "maxUnlockedLevel")
        }
    }
    
    private func generateLevels() {
        // Levels 1-5: Learning Phase
        for i in 1...5 {
            levels.append(Level(
                number: i,
                boardSize: 7,
                candyTypes: 4,
                movesAllowed: 30 + (5 - i),
                timeAllowed: 120,
                targetScore: 1000 + (i * 200),
                objective: .reachScore,
                hasJelly: false,
                hasIce: false,
                hasBlockers: false
            ))
        }
        
        // Levels 6-15: Skill Building
        for i in 6...15 {
            levels.append(Level(
                number: i,
                boardSize: 8,
                candyTypes: 5,
                movesAllowed: 25 + (15 - i),
                timeAllowed: 90 + (15 - i) * 2,
                targetScore: 2000 + (i * 150),
                objective: .reachScore,
                hasJelly: i > 8,
                hasIce: i > 10,
                hasBlockers: false
            ))
        }
        
        // Levels 16-30: Strategy Phase
        for i in 16...30 {
            levels.append(Level(
                number: i,
                boardSize: 9,
                candyTypes: 6,
                movesAllowed: 15 + (30 - i) / 2,
                timeAllowed: 60 + (30 - i) * 2,
                targetScore: 3000 + (i * 100),
                objective: .reachScore,
                hasJelly: true,
                hasIce: i > 20,
                hasBlockers: i > 25
            ))
        }
        
        // Levels 31+: Mastery Phase
        for i in 31...50 {
            levels.append(Level(
                number: i,
                boardSize: 9,
                candyTypes: 7,
                movesAllowed: 10 + (50 - i) / 3,
                timeAllowed: 45 + (50 - i),
                targetScore: 4000 + (i * 80),
                objective: .reachScore,
                hasJelly: true,
                hasIce: true,
                hasBlockers: true
            ))
        }
    }
    
    func getLevel(_ number: Int) -> Level? {
        return levels.first { $0.number == number }
    }
    
    func unlockNextLevel(_ currentLevel: Int) {
        let maxUnlocked = UserDefaults.standard.integer(forKey: "maxUnlockedLevel")
        if currentLevel >= maxUnlocked {
            UserDefaults.standard.set(currentLevel + 1, forKey: "maxUnlockedLevel")
        }
    }
}
