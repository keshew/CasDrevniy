import SwiftUI

struct MenuView: View {
    @StateObject var menuModel =  MenuViewModel()
    let gridSlot = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    let gridCrash = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State var showAlert = false
    @State var isAcihev = false
    @State var isProfile = false
    @State var isSlot1 = false
    @State var isSlot2 = false
    @State var isSlot3 = false
    @State var isSlot4 = false
    @State var isCrash1 = false
    @State var isCrash2 = false
    @State var isCrash3 = false
    @State var isCrash4 = false
    @State var isCrash5 = false
    @State var coins = UserDefaultsManager.shared.coins
    @ObservedObject private var soundManager = SoundManager.shared
    @State var acbiev = [Achiev(name: "First Spin", desc: "Complete your first spin", goal: 1, currentGoal: 0),
                  Achiev(name: "Spin Master", desc: "Complete 100 spins", goal: 100, currentGoal: 0),
                  Achiev(name: "First Win", desc: "Win your first game", goal: 1, currentGoal: 0),
                  Achiev(name: "Big Winner", desc: "Win 10,000 coins in a single spin", goal: 10000, currentGoal: 0),
                  Achiev(name: "Coin Collector", desc: "Accumulate 50,000 coins", goal: 50000, currentGoal: 0)]
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                        Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                Image(.mainbg).resizable().ignoresSafeArea()
                
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
                    Text("NAME GAME")
                        .font(.custom("PaytoneOne-Regular", size: 20))
                        .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255))
                        .shadow(color: Color(red: 255/255, green: 215/255, blue: 0/255), radius: 10)
                    
                    Spacer()
                    
                    HStack(spacing: 15) {
                        Text("Games")
                            .font(.custom("PaytoneOne-Regular", size: 14))
                            .foregroundStyle(.black)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 15)
                            .background(Color(red: 255/255, green: 215/255, blue: 0/255))
                            .cornerRadius(8)
                            .shadow(color: .purple, radius: 10)
                        
                        Button(action: {
                            isAcihev = true
                        }) {
                            HStack {
                                Image("achiev")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                
                                Text("Achievements")
                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                    .foregroundStyle(Color(red: 255/255, green: 240/255, blue: 179/255))
                            }
                        }
                        
                        Button(action: {
                            isProfile = true
                        }) {
                            HStack {
                                Image("profile")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                
                                Text("Profile")
                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                    .foregroundStyle(Color(red: 255/255, green: 240/255, blue: 179/255))
                            }
                        }
                    }
                    
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
                                        
                                        Text("\(coins)")
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
                    VStack(spacing: 20) {
                        VStack(spacing: 5) {
                            Text("NAME GAME")
                                .font(.custom("PaytoneOne-Regular", size: 40))
                                .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255))
                                .shadow(color: Color(red: 255/255, green: 215/255, blue: 0/255), radius: 5)
                            
                            Text("⚡ CHOOSE YOUR GAME ⚡")
                                .font(.custom("PaytoneOne-Regular", size: 17))
                                .foregroundStyle(Color(red: 1/255, green: 255/255, blue: 255/255))
                                .shadow(color: Color(red: 1/255, green: 255/255, blue: 255/255), radius: 5)
                        }
                        
                        HStack(spacing: 20) {
                            Rectangle()
                                .fill(LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                                              Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 169/255, green: 1/255, blue: 255/255).opacity(0.3), lineWidth: 3)
                                        .overlay {
                                            HStack(spacing: 15) {
                                                Circle()
                                                    .fill(Color(red: 169/255, green: 1/255, blue: 255/255).opacity(0.2))
                                                    .overlay {
                                                        Image("level")
                                                            .resizable()
                                                            .frame(width: 24, height: 24)
                                                    }
                                                    .frame(width: 48, height: 48)
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    let totalExp = UserDefaultsManager.shared.totalExperience
                                                    let level = totalExp / 1000 + 1
                                                    
                                                    Text("Your Level")
                                                        .font(.custom("PaytoneOne-Regular", size: 12))
                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                    
                                                    Text("\(level)")
                                                        .font(.custom("PaytoneOne-Regular", size: 20))
                                                        .foregroundStyle(.white)
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(.leading)
                                        }
                                }
                                .frame(height: 100)
                                .cornerRadius(12)
                            
                            Rectangle()
                                .fill(LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                                              Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 2/255, green: 255/255, blue: 128/255).opacity(0.3), lineWidth: 3)
                                        .overlay {
                                            HStack(spacing: 15) {
                                                Circle()
                                                    .fill(Color(red: 2/255, green: 255/255, blue: 128/255).opacity(0.2))
                                                    .overlay {
                                                        Image("arrow")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 24, height: 24)
                                                    }
                                                    .frame(width: 48, height: 48)
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text("Win Rate")
                                                        .font(.custom("PaytoneOne-Regular", size: 12))
                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                    
                                                    
                                                    let totalWins = (1...9).map { UserDefaultsManager.shared.getWins(forGame: $0) }
                                                    let totalPlays = (1...9).map { UserDefaultsManager.shared.getGamesPlayed(forGame: $0) }

                                                    let sumWins = totalWins.reduce(0, +)
                                                    let sumPlays = totalPlays.reduce(0, +)

                                                    let averageWinRate = sumPlays > 0 ? (Double(sumWins) / Double(sumPlays)) * 100 : 0.0

                                                    Text(String(format: "%.1f%%", averageWinRate))
                                                        .font(.custom("PaytoneOne-Regular", size: 20))
                                                        .foregroundStyle(.white)
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(.leading)
                                        }
                                }
                                .frame(height: 100)
                                .cornerRadius(12)
                            
                            Rectangle()
                                .fill(LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                                              Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 13/255, green: 91/255, blue: 98/255).opacity(0.3), lineWidth: 3)
                                        .overlay {
                                            HStack(spacing: 15) {
                                                let totalAchievements = acbiev.count
                                                let unlockedAchievements = acbiev.filter { $0.isUnlocked }.count
                                                
                                                Circle()
                                                    .fill(Color(red: 13/255, green: 91/255, blue: 98/255).opacity(0.2))
                                                    .overlay {
                                                        Image("achiev2")
                                                            .resizable()
                                                            .frame(width: 24, height: 24)
                                                    }
                                                    .frame(width: 48, height: 48)
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text("Achievements")
                                                        .font(.custom("PaytoneOne-Regular", size: 12))
                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                    
                                                    Text("\(unlockedAchievements)/\(totalAchievements)")
                                                        .font(.custom("PaytoneOne-Regular", size: 20))
                                                        .foregroundStyle(.white)
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(.leading)
                                        }
                                }
                                .frame(height: 100)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        VStack {
                            HStack {
                                Image("star")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                
                                Text("Slot Machines")
                                    .font(.custom("PaytoneOne-Regular", size: 20))
                                    .foregroundStyle(Color.white)
                                
                                Image("star")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            
                            LazyVGrid(columns: gridSlot) {
                                ForEach(0..<4, id: \.self) { index in
                                    Button(action: {
                                        switch index {
                                        case 0: isSlot1 = true
                                        case 1: isSlot2 = true
                                        case 2: isSlot3 = true
                                        case 3: isSlot4 = true
                                        default: isSlot1 = true
                                        }
                                    }) {
                                        Image("slot\(index + 1)")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 240, height: 180)
                                    }
                                }
                            }
                        }
                        
                        VStack {
                            HStack {
                                Image("star")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                
                                Text("Instant Games")
                                    .font(.custom("PaytoneOne-Regular", size: 20))
                                    .foregroundStyle(Color.white)
                                
                                Image("star")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            
                            LazyVGrid(columns: gridCrash) {
                                ForEach(0..<8, id: \.self) { index in
                                    if index <= 4 {
                                        Button(action: {
                                            switch index {
                                            case 0: isCrash1 = true
                                            case 1: isCrash2 = true
                                            case 2: isCrash3 = true
                                            case 3: isCrash4 = true
                                            case 4: isCrash5 = true
                                            default: isCrash1 = true
                                            }
                                        }) {
                                            Image("crash\(index + 1)")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 180, height: 180)
                                        }
                                    } else {
                                        Button(action: {
                                            showAlert = true
                                        }) {
                                            ZStack {
                                                Image("crash\(index + 1)")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 180, height: 180)
                                                
                                                Image("closed")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 147, height: 49)
                                            }
                                        }
                                        .alert("It will be open soon!", isPresented: $showAlert) {
                                            Button("OK") {}
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .padding(.top)
        }
        .onAppear() {
            NotificationCenter.default.addObserver(forName: Notification.Name("RefreshData"), object: nil, queue: .main) { _ in
                self.coins = UserDefaultsManager.shared.coins
                
            }
        }
        .fullScreenCover(isPresented: $isAcihev) {
            AchievView()
        }
        .fullScreenCover(isPresented: $isProfile) {
            ProfileView()
        }
        .fullScreenCover(isPresented: $isSlot1) {
            ClassicSlView()
        }
        .fullScreenCover(isPresented: $isSlot2) {
            ClassicSlotsView()
        }
        .fullScreenCover(isPresented: $isSlot3) {
            FishingDeluxeView()
        }
        .fullScreenCover(isPresented: $isSlot4) {
            DragonParadiseView()
        }
        .fullScreenCover(isPresented: $isCrash1) {
            CoinGameView()
        }
        .fullScreenCover(isPresented: $isCrash2) {
            DiceView()
        }
        .fullScreenCover(isPresented: $isCrash3) {
            MineView()
        }
        .fullScreenCover(isPresented: $isCrash4) {
            AviatorView()
        }
        .fullScreenCover(isPresented: $isCrash5) {
            PlinkoView()
        }
        .onAppear() {
            acbiev = loadAchievementsProgress()
        }
    }
    
    func loadAchievementsProgress() -> [Achiev] {
        acbiev.map { achiev in
            var updated = achiev
            switch achiev.name {
                case "First Spin":
                let hasPlayedAny = (1...4).contains { UserDefaultsManager.shared.getGamesPlayed(forGame: $0) > 0 }
                updated.currentGoal = hasPlayedAny ? 1 : 0
                case "Spin Master":
                let totalGamesPlayed = (1...4).reduce(0) { sum, index in
                    sum + UserDefaultsManager.shared.getGamesPlayed(forGame: index)
                }
                updated.currentGoal = totalGamesPlayed
                case "First Win":
                let hasAnyWin = (1...9).contains { UserDefaultsManager.shared.getWins(forGame: $0) > 0 }
                updated.currentGoal = hasAnyWin ? 1 : 0
                case "Big Winner":
                    let maxWin = (1...9).map { UserDefaultsManager.shared.getMaxWin(forGame: $0) }.max() ?? 0
                    updated.currentGoal = maxWin
                case "Coin Collector":
                    updated.currentGoal = UserDefaultsManager.shared.coins
                case "Lucky Seven":
                    updated.currentGoal = 0
                case "Instant Master":
                    updated.currentGoal = UserDefaultsManager.shared.getGamesPlayed(forGame: 0)
                case "High Roller":
                let totalGamesPlayed = (1...4).reduce(0) { sum, index in
                    sum + UserDefaultsManager.shared.getGamesPlayed(forGame: index)
                }
                updated.currentGoal = totalGamesPlayed
                default:
                    updated.currentGoal = 0
            }
            return updated
        }
    }
}

#Preview {
    MenuView()
}
