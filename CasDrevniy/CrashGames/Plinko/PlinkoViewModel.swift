import SwiftUI

class PlinkoViewModel: ObservableObject {
    let contact = PlinkoModel()
    @Published var coin = UserDefaultsManager.shared.coins
    @Published var bet = 100
    @Published var win = 0

    func createGameScene(gameData: GameData) -> GameSpriteKit {
        let scene = GameSpriteKit()
        scene.game  = gameData
        return scene
    }
}
