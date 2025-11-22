import SwiftUI

class DiceViewModel: ObservableObject {
    let contact = DiceModel()
    @Published var coin = UserDefaultsManager.shared.coins
    @Published var bet = 50
    @Published var dice1Value: Int = 1
    @Published var dice2Value: Int = 1
    @Published var diceTotal: Int = 2
    @Published var payoutMultiplier: Int = 1
    @Published var dice1Rotation: Double = 0
    @Published var dice2Rotation: Double = 0
    
    private func rollDice() -> Int {
        Int.random(in: 1...6)
    }

    func rollBothDiceWithAnimation() {
        guard coin > bet else { return }
        UserDefaultsManager.shared.incrementGamesPlayed(forGame: 7)
        UserDefaultsManager.shared.removeCoins(bet)
        coin = UserDefaultsManager.shared.coins
        
        withAnimation(.easeInOut(duration: 0.6)) {
            dice1Rotation += 720
            dice2Rotation += 720
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.dice1Value = Int.random(in: 1...6)
            self.dice2Value = Int.random(in: 1...6)
            self.diceTotal = self.dice1Value + self.dice2Value
            self.dice1Rotation = 0
            self.dice2Rotation = 0
            self.calculatePayout()
        }
    }
    
    private func calculatePayout() {
        if dice1Value == 6 && dice2Value == 6 {
            payoutMultiplier = 10
            UserDefaultsManager.shared.addCoins(bet * payoutMultiplier)
            coin = UserDefaultsManager.shared.coins
            UserDefaultsManager.shared.incrementWins(forGame: 7)
            UserDefaultsManager.shared.updateMaxWin(forGame: 7, winAmount: bet * payoutMultiplier)
        } else if dice1Value == dice2Value {
            payoutMultiplier = 5
            UserDefaultsManager.shared.addCoins(bet * payoutMultiplier)
            coin = UserDefaultsManager.shared.coins
            UserDefaultsManager.shared.incrementWins(forGame: 7)
            UserDefaultsManager.shared.updateMaxWin(forGame: 7, winAmount: bet * payoutMultiplier)
        } else if diceTotal == 7 || diceTotal == 11 {
            payoutMultiplier = 3
            UserDefaultsManager.shared.addCoins(bet * payoutMultiplier)
            coin = UserDefaultsManager.shared.coins
            UserDefaultsManager.shared.incrementWins(forGame: 7)
            UserDefaultsManager.shared.updateMaxWin(forGame: 7, winAmount: bet * payoutMultiplier)
        } else if diceTotal >= 9 {
            payoutMultiplier = 2
            UserDefaultsManager.shared.addCoins(bet * payoutMultiplier)
            coin = UserDefaultsManager.shared.coins
            UserDefaultsManager.shared.incrementWins(forGame: 7)
            UserDefaultsManager.shared.updateMaxWin(forGame: 7, winAmount: bet * payoutMultiplier)
        } else {
            payoutMultiplier = 1
        }
    }
}
