import SwiftUI

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    var coins: Int {
        get { defaults.integer(forKey: "coins") }
        set { defaults.set(newValue, forKey: "coins") }
    }
    
    var totalExperience: Int {
        get { defaults.integer(forKey: "totalExperience") }
        set { defaults.set(newValue, forKey: "totalExperience") }
    }
    
    func addCoins(_ amount: Int) {
        coins += amount
    }
    
    func removeCoins(_ amount: Int) {
        coins = max(coins - amount, 0)
    }
    
    // MARK: - Game Stats
    
    func incrementGamesPlayed(forGame index: Int) {
        let key = "game\(index)Played"
        defaults.set(defaults.integer(forKey: key) + 1, forKey: key)
        addExperience()
    }
    
    func incrementWins(forGame index: Int) {
        let key = "game\(index)Wins"
        defaults.set(defaults.integer(forKey: key) + 1, forKey: key)
    }
    
    func updateMaxWin(forGame index: Int, winAmount: Int) {
        let key = "game\(index)MaxWin"
        let currentMax = defaults.integer(forKey: key)
        if winAmount > currentMax {
            defaults.set(winAmount, forKey: key)
        }
    }
    
    func getGamesPlayed(forGame index: Int) -> Int {
        defaults.integer(forKey: "game\(index)Played")
    }
    
    func getWins(forGame index: Int) -> Int {
        defaults.integer(forKey: "game\(index)Wins")
    }
    
    func getMaxWin(forGame index: Int) -> Int {
        defaults.integer(forKey: "game\(index)MaxWin")
    }
    
    func getWinPercentage(forGame index: Int) -> Double {
        let played = getGamesPlayed(forGame: index)
        let wins = getWins(forGame: index)
        guard played > 0 else { return 0.0 }
        return (Double(wins) / Double(played)) * 100.0
    }
    
    func resetGameStats(forGame index: Int) {
        defaults.removeObject(forKey: "game\(index)Played")
        defaults.removeObject(forKey: "game\(index)Wins")
        defaults.removeObject(forKey: "game\(index)MaxWin")
    }
    
    func resetAllStats() {
        for i in 1...9 {
            resetGameStats(forGame: i)
        }
    }
    
    func resetAllData() {
        resetAllStats()
        coins = 5000
    }
    
    func addExperience() {
        totalExperience += 10
    }
}
