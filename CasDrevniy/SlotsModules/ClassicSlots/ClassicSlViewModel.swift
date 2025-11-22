import SwiftUI

class ClassicSlViewModel: ObservableObject {
    let contact = ClassicSlModel()
    @Published var slots: [[String]] = []
    @Published var coin =   UserDefaultsManager.shared.coins
    @Published var bet = 5
    let allFruits = ["slotcas1", "slotcas2", "slotcas3","slotcas4", "slotcas5", "slotcas6"]
    @Published var winningPositions: [(row: Int, col: Int)] = []
    @Published var isSpinning = false
    @Published var isStopSpininng = false
    @Published var isWin = false
    @Published var win = 0
    var spinningTimer: Timer?
    @ObservedObject private var soundManager = SoundManager.shared
    
    init() {
        resetSlots()
    }
    
    @Published var betString: String = "5" {
        didSet {
            if let newBet = Int(betString), newBet > 0 {
                bet = newBet
            }
        }
    }
    let symbolArray = [
        Symbol(image: "slotcas1", value: "100"),
        Symbol(image: "slotcas2", value: "50"),
        Symbol(image: "slotcas3", value: "20"),
        Symbol(image: "slotcas4", value: "15"),
        Symbol(image: "slotcas5", value: "5"),
        Symbol(image: "slotcas6", value: "3")
    ]
    
    func resetSlots() {
        slots = (0..<3).map { _ in
            (0..<5).map { _ in
                allFruits.randomElement()!
            }
        }
    }
    
    func spin() {
        UserDefaultsManager.shared.incrementGamesPlayed(forGame: 1)
        UserDefaultsManager.shared.removeCoins(bet)
        coin =  UserDefaultsManager.shared.coins
        isSpinning = true
        soundManager.playSlot1()
        spinningTimer?.invalidate()
        winningPositions.removeAll()
        win = 0
        let columns = 5
        for col in 0..<columns {
            let delay = Double(col) * 0.4
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                var spinCount = 0
                let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                    for row in 0..<3 {
                        withAnimation(.spring(response: 0.1, dampingFraction: 1.5, blendDuration: 0)) {
                            self.slots[row][col] = self.allFruits.randomElement()!
                        }
                    }
                    spinCount += 1
                    if spinCount > 12 + col * 4 {
                        timer.invalidate()
                        if col == columns - 1 {
                            self.isSpinning = false
                            self.soundManager.stopSlot()
                            self.checkWin()
                        }
                    }
                }
                RunLoop.current.add(timer, forMode: .common)
            }
        }
    }
    
    
    func checkWin() {
        winningPositions = []
        var totalWin = 0
        var maxMultiplier = 0
        let minCounts = [
            "slotcas1": 5,
            "slotcas2": 5,
            "slotcas3": 5,
            "slotcas4": 5,
            "slotcas5": 5,
            "slotcas6": 5
        ]
        let multipliers = [
            "slotcas1": 100,
            "slotcas2": 50,
            "slotcas3": 25,
            "slotcas4": 15,
            "slotcas5": 5,
            "slotcas6": 3
        ]
        
        for row in 0..<3 {
            let rowContent = slots[row]
            var currentSymbol = rowContent[0]
            var count = 1
            for col in 1..<rowContent.count {
                if rowContent[col] == currentSymbol {
                    count += 1
                } else {
                    if let minCount = minCounts[currentSymbol], count >= minCount {
                        totalWin += multipliers[currentSymbol] ?? 0
                        if let multiplierValue = multipliers[currentSymbol], multiplierValue > maxMultiplier {
                            maxMultiplier = multiplierValue
                        }
                        let startCol = col - count
                        for c in startCol..<col {
                            winningPositions.append((row: row, col: c))
                        }
                    }
                    currentSymbol = rowContent[col]
                    count = 1
                }
            }
            if let minCount = minCounts[currentSymbol], count >= minCount {
                totalWin += multipliers[currentSymbol] ?? 0
                if let multiplierValue = multipliers[currentSymbol], multiplierValue > maxMultiplier {
                    maxMultiplier = multiplierValue
                }
                let startCol = rowContent.count - count
                for c in startCol..<rowContent.count {
                    winningPositions.append((row: row, col: c))
                }
            }
        }
        
        if totalWin != 0 {
            win = totalWin
            isWin = true
            UserDefaultsManager.shared.addCoins(totalWin)
            coin = UserDefaultsManager.shared.coins
            UserDefaultsManager.shared.incrementWins(forGame: 1)
            UserDefaultsManager.shared.updateMaxWin(forGame: 1, winAmount: win)
        }
    }
}
