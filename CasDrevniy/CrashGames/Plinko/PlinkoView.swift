import SpriteKit
import Combine
import SwiftUI

class GameData: ObservableObject {
    @Published var reward: Double = 0.0
    @Published var bet: Int = 50

    @Published var balance: Int = UserDefaultsManager.shared.coins
    @Published var isPlayTapped: Bool = false
    @Published var labels: [String] = ["1x", "1.5x", "2x", "5x", "10x", "5x", "2x", "1.5x", "1x"]
    
    var createBallPublisher = PassthroughSubject<Void, Never>()
    
    var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: balance)) ?? "\(balance)"
    }
    
    
    func decreaseBet() {
        if bet - 5 >= 5 {
            bet -= 5
        }
    }
    func increaseBet() {
        let newBet = bet + 5
        if newBet <= balance {
            bet = newBet
        }
    }
    
    
    func dropBalls() {
        guard bet <= balance else {
            return
        }
        let _ = UserDefaultsManager.shared.removeCoins(bet)
        balance = UserDefaultsManager.shared.coins
        UserDefaultsManager.shared.incrementGamesPlayed(forGame: 9)
        reward = 0.0
        isPlayTapped = true
        createBallPublisher.send(())
    }
    
    func resetGame() {
        bet = 50
        reward = 0
        isPlayTapped = false
    }
    
    func addWin(_ amount: Double) {
        reward += amount
        UserDefaultsManager.shared.incrementWins(forGame: 8)
        UserDefaultsManager.shared.updateMaxWin(forGame: 8, winAmount: Int(amount))
    }
    
    func finishGame() {
        UserDefaultsManager.shared.addCoins(Int(reward))
        balance = UserDefaultsManager.shared.coins
        reward = 0
        isPlayTapped = false
    }
}

class GameSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: GameData? {
        didSet {
        }
    }
    
    let ballCategory: UInt32 = 0x1 << 0
    let obstacleCategory: UInt32 = 0x1 << 1
    let ticketCategory: UInt32 = 0x1 << 2
    
    var ballsInPlay: Int = 0
    var ballNodes: [SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        size = UIScreen.main.bounds.size
        backgroundColor = .clear
        
        createObstacles()
        createTickets()
        createInitialBalls()
        
        game?.createBallPublisher.sink { [weak self] in
            self?.launchBalls()
        }.store(in: &cancellables)
    }
    
    var cancellables = Set<AnyCancellable>()
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        for (index, ball) in ballNodes.enumerated().reversed() {
            if ball.position.y < 0 || ball.position.x < 0 || ball.position.x > size.width {
                ball.removeFromParent()
                ballNodes.remove(at: index)
                ballsInPlay -= 1
                createBall(atIndex: index)
            }
        }
    }
    
    func createObstacles() {
        let startRowCount = 2
        let numberOfRows = 5
        let obstacleSize = CGSize(width: /*size.width > 1000 ? 30 : */30, height: /*size.width > 1000 ? 40 : */20)
        let horizontalSpacing: CGFloat = /*size.width > 1000 ? 90 :*/ 95
        
        for row in 0..<numberOfRows {
            let countInRow = startRowCount + row
            let totalWidth = CGFloat(countInRow) * (obstacleSize.width + horizontalSpacing) - horizontalSpacing
            let xOffset = (size.width - totalWidth) / 2 + obstacleSize.width / 2
            let yPosition = (/*UIScreen.main.bounds.width > 1000 ? size.height / 1.35 : */size.height / 1.32) - CGFloat(row) * (obstacleSize.height +/* UIScreen.main.bounds.width > 1000 ? 105 : */35)
            
            for col in 0..<countInRow {
                let obstacle = SKSpriteNode(imageNamed: "obstacle")
                obstacle.size = obstacleSize
                let xPosition = xOffset + CGFloat(col) * (obstacleSize.width + horizontalSpacing)
                obstacle.position = CGPoint(x: xPosition, y: yPosition)
                
                obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacleSize.width / 2.0)
                obstacle.physicsBody?.isDynamic = false
                obstacle.physicsBody?.categoryBitMask = obstacleCategory
                obstacle.physicsBody?.contactTestBitMask = ballCategory
                
                addChild(obstacle)
            }
        }
    }
    
    func createTickets() {
        guard let game = self.game else { return }
        let labels = game.labels
        let count = labels.count
        let ticketWidth: CGFloat = 82
        let horizontalSpacing: CGFloat = 15
        let totalWidth = CGFloat(count) * (ticketWidth + horizontalSpacing) - horizontalSpacing
        let xOffset = (size.width - totalWidth) / 2 + ticketWidth / 2
        let yPosition = size.height / 17.5

        for i in 0..<count {
            let label = SKLabelNode(text: labels[i])
            label.fontName = "PaytoneOne-Regular"
            label.fontSize = 18
            label.fontColor = UIColor(red: 253/255, green: 255/255, blue: 193/255, alpha: 1)
            label.verticalAlignmentMode = .center
            label.horizontalAlignmentMode = .center
            label.position = CGPoint(x: 0, y: 0)
            label.xScale = 1.5
            label.yScale = 1
            label.name = "ticket_\(i)"

            let colorsPattern: [UIColor] = [
                UIColor(red: 216/255, green: 151/255, blue: 0/255, alpha: 0.3),
                UIColor(red: 216/255, green: 151/255, blue: 0/255, alpha: 0.3),
                UIColor(red: 59/255, green: 130/255, blue: 246/255, alpha: 0.3),
                UIColor(red: 59/255, green: 130/255, blue: 246/255, alpha: 0.3),
                UIColor(red: 194/255, green: 0/255, blue: 6/255, alpha: 0.3),
                UIColor(red: 59/255, green: 130/255, blue: 246/255, alpha: 0.3),
                UIColor(red: 59/255, green: 130/255, blue: 246/255, alpha: 0.3),
                UIColor(red: 216/255, green: 151/255, blue: 0/255, alpha: 0.3),
                UIColor(red: 216/255, green: 151/255, blue: 0/255, alpha: 0.3)
            ]
            let color = colorsPattern[i % colorsPattern.count]

            let backgroundSize = CGSize(width: ticketWidth + 10, height: label.frame.height + 25)
            let backgroundNode = SKShapeNode(rectOf: backgroundSize, cornerRadius: 3)
            backgroundNode.fillColor = color
            backgroundNode.strokeColor = UIColor.clear
            backgroundNode.position = CGPoint(x: xOffset + CGFloat(i) * (ticketWidth + horizontalSpacing), y: yPosition)
            backgroundNode.zPosition = label.zPosition - 1

            backgroundNode.physicsBody = SKPhysicsBody(rectangleOf: backgroundSize)
            backgroundNode.physicsBody?.isDynamic = false
            backgroundNode.physicsBody?.categoryBitMask = ticketCategory
            backgroundNode.physicsBody?.contactTestBitMask = ballCategory

            backgroundNode.addChild(label)

            addChild(backgroundNode)
        }
    }
    
    func createInitialBalls() {
        
        ballNodes.forEach { $0.removeFromParent() }
        ballNodes.removeAll()
        ballsInPlay = 0
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: 35, height: 22)
        ball.position = CGPoint(x: size.width / 2,
                                y: size.height / 1.15)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 3)
        ball.physicsBody?.restitution = 0.7
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.linearDamping = 0.2
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.collisionBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.isDynamic = true
        
        addChild(ball)
        ballNodes.append(ball)
        ballsInPlay += 1
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let game = game else { return }
        
        let ballCategory = self.ballCategory
        let ticketCategory = self.ticketCategory
        
        var ballNode: SKNode?
        var ticketNode: SKNode?
        
        if contact.bodyA.categoryBitMask == ballCategory {
            ballNode = contact.bodyA.node
        } else if contact.bodyB.categoryBitMask == ballCategory {
            ballNode = contact.bodyB.node
        }
        
        if contact.bodyA.categoryBitMask == ticketCategory {
            ticketNode = contact.bodyA.node
        } else if contact.bodyB.categoryBitMask == ticketCategory {
            ticketNode = contact.bodyB.node
        }
        
        guard let ball = ballNode as? SKSpriteNode,
              let ticketBackground = ticketNode as? SKShapeNode else {
            return
        }
        
        guard let ticketLabel = ticketBackground.children.compactMap({ $0 as? SKLabelNode }).first(where: {
            $0.name?.starts(with: "ticket_") == true
        }) else {
            print("Ticket label not found as child of ticket background node")
            return
        }
        
        guard let multiplier = parseMultiplier(from: ticketLabel.text) else {
            print("Failed to parse multiplier from label \(ticketLabel.text ?? "")")
            return
        }
        
        let win = Double(game.bet) * multiplier
        game.addWin(win)
        
        ball.removeFromParent()
        if let index = ballNodes.firstIndex(of: ball) {
            ballNodes.remove(at: index)
        }
        
        ballsInPlay -= 1
        
        createBall(atIndex: 0)
        
        checkBallsStopped()
    }

    
    func createBall(atIndex index: Int) {
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: 35, height: 22)
        ball.position = CGPoint(x: size.width / 2,
                                y: size.height / 1.15)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 3)
        ball.physicsBody?.restitution = 0.7
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.linearDamping = 0.2
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.collisionBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.isDynamic = true
        
        addChild(ball)
        ballNodes.append(ball)
        ballsInPlay += 1
    }
    
    func launchBalls() {
        for (_, ball) in ballNodes.enumerated() {
            ball.physicsBody?.affectedByGravity = true
            
            let randomXImpulse = CGFloat.random(in: -0.01...0.01)
            
            ball.physicsBody?.applyImpulse(CGVector(dx: randomXImpulse, dy: 0))
        }
    }
    
    private func parseMultiplier(from text: String?) -> Double? {
        guard let text = text?.lowercased().replacingOccurrences(of: "x", with: "") else { return nil }
        return Double(text)
    }
    
    private func checkBallsStopped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self, let game = self.game else { return }
            let movingBalls = self.ballNodes.filter {
                guard let body = $0.physicsBody else { return false }
                return body.velocity.dx > 5 || body.velocity.dy > 5
            }
            if movingBalls.isEmpty && game.isPlayTapped {
                game.finishGame()
            }
        }
    }
}

struct PlinkoView: View {
    @StateObject var viewModel =  PlinkoViewModel()
    @StateObject var gameModel = GameData()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                        Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                Image("bgPlinko").resizable().ignoresSafeArea()
                
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                                      Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom))
                        .frame(height: UIScreen.main.bounds.width > 1200 ? 95 : 65)
                    
                    Rectangle()
                        .fill(Color(red: 255/255, green: 215/255, blue: 0/255))
                        .frame(height: 1)
                }
                .ignoresSafeArea()
            }
            
            VStack(spacing: 7) {
                HStack {
                    Button(action: {
                        NotificationCenter.default.post(name: Notification.Name("RefreshData"), object: nil)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    Text("NAME GAME")
                        .font(.custom("PaytoneOne-Regular", size: 20))
                        .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255))
                        .shadow(color: Color(red: 255/255, green: 215/255, blue: 0/255), radius: 10)
                    
                    Spacer()
              
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 112, height: 42)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.3), lineWidth: 3)
                                .overlay {
                                    HStack(spacing: 10) {
                                        Image("coin")
                                            .resizable()
                                            .frame(width: 31, height: 33)
                                        
                                        Text("\(gameModel.balance)")
                                            .font(.custom("PaytoneOne-Regular", size: 16))
                                            .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255))
                                    }
                                }
                        }
                        .cornerRadius(16)
                        .shadow(color: Color(red: 255/255, green: 215/255, blue: 0/255), radius: 5)
                    
                    Rectangle()
                        .fill(Color(red: 1/255, green: 255/255, blue: 255/255).opacity(0.3))
                        .frame(width: 80, height: 38)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(red: 1/255, green: 255/255, blue: 255/255).opacity(0.5), lineWidth: 3)
                                .overlay {
                                    HStack(spacing: 8) {
                                        let totalExp = UserDefaultsManager.shared.totalExperience
                                        let level = totalExp / 1000 + 1
                                        Image("level")
                                            .resizable()
                                            .frame(width: 16, height: 16)
                                        
                                        Text("Lv. \(level)")
                                            .font(.custom("PaytoneOne-Regular", size: 14))
                                            .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255))
                                    }
                                }
                        }
                        .cornerRadius(16)
                }
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        Rectangle()
                            .fill(Color(red: 20/255, green: 20/255, blue: 31/255).opacity(0.95))
                            .frame(width: 450, height: 310)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 169/255, green: 1/255, blue: 255/255).opacity(0.3), lineWidth: 2)
                                    .overlay {
                                        VStack(spacing: 15) {
                                            Rectangle()
                                                .fill(LinearGradient(colors: [Color(red: 30/255, green: 58/255, blue: 138/255),
                                                                              Color(red: 29/255, green: 27/255, blue: 75/255)], startPoint: .top, endPoint: .bottom))
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(Color(red: 6/255, green: 182/255, blue: 212/255).opacity(0.5), lineWidth: 2)
                                                        .overlay {
                                                            SpriteView(scene: viewModel.createGameScene(gameData: gameModel), options: [.allowsTransparency])
                                                                .frame(width:/* UIScreen.main.bounds.width > 700 ? 750 : */250, height: /*UIScreen.main.bounds.width > 700 ? 350 : */ 190)
                                                        }
                                                }
                                                .frame(width: 250, height: 190)
                                                .cornerRadius(16)
                                            HStack(spacing: 20) {
                                                Button(action: {
                                                    gameModel.decreaseBet()
                                                }) {
                                                    Rectangle()
                                                        .fill(Color(red: 46/255, green: 31/255, blue: 31/255))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.3), lineWidth: 3)
                                                                .overlay {
                                                                    Text("-")
                                                                        .font(.custom("PaytoneOne-Regular", size: 20))
                                                                        .foregroundStyle(.white)
                                                                        .offset(y: -3)
                                                                }
                                                        }
                                                        .frame(width: 30, height: 30)
                                                        .cornerRadius(10)
                                                }
                                                .shadow(color: Color(red: 169/255, green: 1/255, blue: 255/255), radius: 5)
                                                
                                                VStack(spacing: 0) {
                                                    Text("Bet Amount")
                                                        .font(.custom("PaytoneOne-Regular", size: 10))
                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                    
                                                    Text("Bet: \(gameModel.bet)")
                                                        .font(.custom("PaytoneOne-Regular", size: 18))
                                                        .foregroundStyle(.white)
                                                }
                                                
                                                Button(action: {
                                                    gameModel.increaseBet()
                                                }) {
                                                    Rectangle()
                                                        .fill(Color(red: 46/255, green: 31/255, blue: 31/255))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.3), lineWidth: 3)
                                                                .overlay {
                                                                    Text("+")
                                                                        .font(.custom("PaytoneOne-Regular", size: 20))
                                                                        .foregroundStyle(.white)
                                                                        .offset(y: -3)
                                                                }
                                                        }
                                                        .frame(width: 30, height: 30)
                                                        .cornerRadius(10)
                                                }
                                                .shadow(color: Color(red: 169/255, green: 1/255, blue: 255/255), radius: 5)
                                            }
                                            
                                            Button(action: {
                                                withAnimation {
                                                    gameModel.dropBalls()
                                                }
                                            }) {
                                                Rectangle()
                                                    .fill(Color(red: 255/255, green: 191/255, blue: 1/255))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .stroke(Color(red: 171/255, green: 0/255, blue: 255/255), lineWidth: 2)
                                                            .overlay {
                                                                Text("DROP BALL")
                                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                                    .foregroundStyle(.white)
                                                            }
                                                    }
                                                    .frame(width: 109, height: 26)
                                                    .cornerRadius(6)
                                            }
                                        }
                                    }
                            }
                            .cornerRadius(12)
                    }
                    .padding(.top, 15)
                }
            }
            .padding(.top)
        }
    }
}

#Preview {
    PlinkoView()
}

