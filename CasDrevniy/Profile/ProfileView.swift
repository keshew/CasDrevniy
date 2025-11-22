import SwiftUI

struct GameStats {
    let id: Int
    let name: String
    let spins: Int
    let bestWin: Int
    let winRate: Double
}

struct FavoriteGameStats {
    let name: String
    let spins: Int
    let wins: Int
    let best: Int
}


struct ProfileView: View {
    @StateObject var profileModel =  ProfileViewModel()
    @Environment(\.presentationMode) var presentationMode
    let games = [
        "Classic Slots", "Dragon Paradise", "Fishing Deluxe", "Medieval Spins",
        "Rocket Crash", "Coin Flip", "Lucky Dice", "Diamond Mines", "Plinko Drop"
    ]
    
    var gameStats: [GameStats] {
        games.enumerated().map { index, name in
            let gameIndex = index + 1
            return GameStats(
                id: gameIndex,
                name: name,
                spins: UserDefaultsManager.shared.getGamesPlayed(forGame: gameIndex),
                bestWin: UserDefaultsManager.shared.getMaxWin(forGame: gameIndex),
                winRate: UserDefaultsManager.shared.getWinPercentage(forGame: gameIndex)
            )
        }
    }
    
    let allGames = [
        "Classic Slots", "Dragon Paradise", "Fishing Deluxe", "Medieval Spins",
        "Rocket Crash", "Coin Flip", "Lucky Dice", "Diamond Mines", "Plinko Drop"
    ]

    var favoriteGame: FavoriteGameStats {
        let stats = allGames.enumerated().map { index, name in
            FavoriteGameStats(
                name: name,
                spins: UserDefaultsManager.shared.getGamesPlayed(forGame: index + 1),
                wins: UserDefaultsManager.shared.getWins(forGame: index + 1),
                best: UserDefaultsManager.shared.getMaxWin(forGame: index + 1)
            )
        }
        return stats.max(by: { $0.spins < $1.spins }) ?? stats[0]
    }

    @State var coins = UserDefaultsManager.shared.coins
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                        Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                Image("bgProfile").resizable().ignoresSafeArea()
                
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
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            NotificationCenter.default.post(name: Notification.Name("RefreshData"), object: nil)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Games")
                                .font(.custom("PaytoneOne-Regular", size: 14))
                                .foregroundStyle(Color(red: 255/255, green: 240/255, blue: 179/255))
                        }
                        
                        Button(action: {
                            NotificationCenter.default.post(name: Notification.Name("RefreshData"), object: nil)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image("achiev2")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                
                                Text("Achievements")
                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                    .foregroundStyle(Color(red: 255/255, green: 240/255, blue: 179/255))
                            }
                        }
                        
                        HStack {
                            Image("profile2")
                                .resizable()
                                .frame(width: 16, height: 16)
                            
                            Text("Profile")
                                .font(.custom("PaytoneOne-Regular", size: 14))
                                .foregroundStyle(Color.black)
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(Color(red: 255/255, green: 215/255, blue: 0/255))
                        .cornerRadius(8)
                        .shadow(color: .purple, radius: 10)
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
                        VStack {
                            let totalExp = UserDefaultsManager.shared.totalExperience
                            let level = totalExp / 1000 + 1
                            
                            ZStack(alignment: .bottomTrailing) {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 255/255, green: 132/255, blue: 66/255))
                                        .frame(width: 95, height: 95)
                                    Circle()
                                        .fill(LinearGradient(colors: [Color(red: 255/255, green: 215/255, blue: 0/255),
                                                                      Color(red: 255/255, green: 0/255, blue: 170/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .frame(width: 90, height: 90)
                                }
                                
                                Rectangle()
                                    .fill(Color(red: 1/255, green: 255/255, blue: 255/255))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 17)
                                            .stroke(Color(red: 255/255, green: 215/255, blue: 0/255), lineWidth: 3)
                                            .overlay {
                                                Text("Lv. \(level)")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color.black)
                                            }
                                    }
                                    .frame(width: 47, height: 28)
                                    .cornerRadius(17)
                            }
                            
                            Text("Player")
                                .font(.custom("PaytoneOne-Regular", size: 24))
                                .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255))
                                .shadow(color: Color(red: 169/255, green: 1/255, blue: 255/255), radius: 10)
                        }
                        
                        VStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color(red: 20/255, green: 20/255, blue: 31/255).opacity(0.95))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.5), lineWidth: 2)
                                        .overlay {
                                            VStack(spacing: 15) {
                                                let totalExp = UserDefaultsManager.shared.totalExperience
                                                let level = totalExp / 1000 + 1
                                                let currentLevelExp = totalExp % 1000
                                                let nextLevelExp = 1000
                                                let progress = CGFloat(currentLevelExp) / CGFloat(nextLevelExp)

                                                HStack {
                                                    Text("Level Progress")
                                                        .font(.custom("PaytoneOne-Regular", size: 12))
                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                    
                                                    Spacer()
                                                    
                                                    Text("\(totalExp)/\(level)000 XP")
                                                        .font(.custom("PaytoneOne-Regular", size: 12))
                                                        .foregroundStyle(Color.white)
                                                }
                                                
                                                GeometryReader { geometry in
                                                    ZStack(alignment: .leading) {
                                                        Rectangle()
                                                            .fill(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.2))
                                                            .frame(width: geometry.size.width, height: 8)
                                                            .cornerRadius(10)

                                                        Rectangle()
                                                            .fill(Color(red: 255/255, green: 215/255, blue: 0/255))
                                                            .frame(width: geometry.size.width * progress, height: 8)
                                                            .cornerRadius(10)
                                                    }
                                                }
                                                .frame(height: 8)
                                                
                                                Text("\(nextLevelExp - currentLevelExp) XP until Level \(level + 1)")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                            }
                                            .padding()
                                        }
                                }
                                .frame(height: 110)
                                .cornerRadius(12)
                                .padding(.horizontal)
                            
                            HStack(spacing: 20) {
                                Rectangle()
                                    .fill(LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                                                  Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 2/255, green: 255/255, blue: 128/255).opacity(0.3), lineWidth: 3)
                                            .overlay {
                                                VStack(alignment: .leading, spacing: 10) {
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
                                                    
                                                    Text("1 wins out of 1 spins")
                                                        .font(.custom("PaytoneOne-Regular", size: 12))
                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                }
                                                .padding(.leading)
                                            }
                                    }
                                    .frame(height: 110)
                                    .cornerRadius(12)
                                
                                Rectangle()
                                    .fill(LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                                                  Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.3), lineWidth: 3)
                                            .overlay {
                                                VStack(alignment: .leading, spacing: 10) {
                                                    HStack(spacing: 15) {
                                                        Circle()
                                                            .fill(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.2))
                                                            .overlay {
                                                                Image("achiev3")
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
                                                                    .frame(width: 24, height: 24)
                                                            }
                                                            .frame(width: 48, height: 48)
                                                        
                                                        VStack(alignment: .leading, spacing: 0) {
                                                            Text("Biggest Win")
                                                                .font(.custom("PaytoneOne-Regular", size: 12))
                                                                .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                            

                                                            let maxWins = (1...9).map { UserDefaultsManager.shared.getMaxWin(forGame: $0) }
                                                            let biggestWin = maxWins.max() ?? 0
                                                            
                                                            Text("\(biggestWin)")
                                                                .font(.custom("PaytoneOne-Regular", size: 20))
                                                                .foregroundStyle(.white)
                                                        }
                                                        
                                                        Spacer()
                                                    }
                                                    
                                                    Text("coins in a single spin")
                                                        .font(.custom("PaytoneOne-Regular", size: 12))
                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                }
                                                .padding(.leading)
                                            }
                                    }
                                    .frame(height: 110)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            
                            Rectangle()
                                .fill(LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                                              Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 1/255, green: 255/255, blue: 255/255).opacity(0.3), lineWidth: 3)
                                        .overlay {
                                            VStack(alignment: .leading, spacing: 10) {
                                                HStack(spacing: 15) {
                                                    Circle()
                                                        .fill(Color(red: 1/255, green: 255/255, blue: 255/255).opacity(0.2))
                                                        .overlay {
                                                            Image("favGame")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 24, height: 24)
                                                        }
                                                        .frame(width: 48, height: 48)
                                                    
                                                    VStack(alignment: .leading, spacing: 0) {
                                                        Text("Favorite Game")
                                                            .font(.custom("PaytoneOne-Regular", size: 20))
                                                            .foregroundStyle(.white)
                                                        
                                                        Text(favoriteGame.name)
                                                            .font(.custom("PaytoneOne-Regular", size: 12))
                                                            .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                    }
                                                    
                                                    Spacer()
                                                }
                                                
                                                HStack {
                                                    Spacer()
                                                    VStack {
                                                        Text("Spins")
                                                            .font(.custom("PaytoneOne-Regular", size: 14))
                                                            .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                        
                                                        Text("\(favoriteGame.spins)")
                                                            .font(.custom("PaytoneOne-Regular", size: 16))
                                                            .foregroundStyle(Color.white)
                                                    }
                                                    Spacer()
                                                    VStack {
                                                        Text("Wins")
                                                            .font(.custom("PaytoneOne-Regular", size: 14))
                                                            .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                        
                                                        Text("\(favoriteGame.wins)")
                                                            .font(.custom("PaytoneOne-Regular", size: 16))
                                                            .foregroundStyle(Color(red: 2/255, green: 255/255, blue: 128/255))
                                                    }
                                                    Spacer()
                                                    VStack {
                                                        Text("Best")
                                                            .font(.custom("PaytoneOne-Regular", size: 14))
                                                            .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                        
                                                        Text("\(favoriteGame.best)")
                                                            .font(.custom("PaytoneOne-Regular", size: 16))
                                                            .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255))
                                                    }
                                                    Spacer()
                                                }
                                            }
                                            .padding(.leading)
                                        }
                                }
                                .frame(height: 130)
                                .cornerRadius(12)
                                .padding(.horizontal)
                            
                            Text("Game Statistics")
                                .font(.custom("PaytoneOne-Regular", size: 20))
                                .foregroundStyle(.white)
                                .padding(.horizontal)
                            
                            ForEach(gameStats, id: \.id) { game in
                                Rectangle()
                                    .fill(.black.opacity(0.5))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.3), lineWidth: 3)
                                            .overlay {
                                                VStack(alignment: .leading, spacing: 20) {
                                                    HStack(spacing: 15) {
                                                        HStack() {
                                                            Text(game.name)
                                                                .font(.custom("PaytoneOne-Regular", size: 16))
                                                                .foregroundStyle(.white)

                                                            Spacer()
                                                        }
                                                        .padding(.horizontal)
                                                    }

                                                    HStack {
                                                        Spacer()
                                                        VStack {
                                                            Text("Spins")
                                                                .font(.custom("PaytoneOne-Regular", size: 14))
                                                                .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                            
                                                            Text("\(game.spins)")
                                                                .font(.custom("PaytoneOne-Regular", size: 16))
                                                                .foregroundStyle(Color.white)
                                                        }
                                                        Spacer()
                                                        VStack {
                                                            Text("Best Win")
                                                                .font(.custom("PaytoneOne-Regular", size: 14))
                                                                .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                            
                                                            Text("\(game.bestWin)")
                                                                .font(.custom("PaytoneOne-Regular", size: 16))
                                                                .foregroundStyle(Color(red: 2/255, green: 255/255, blue: 128/255))
                                                        }
                                                        Spacer()
                                                        VStack {
                                                            Text("Win Rate")
                                                                .font(.custom("PaytoneOne-Regular", size: 14))
                                                                .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                            
                                                            Text(String(format: "%.1f%%", game.winRate))
                                                                .font(.custom("PaytoneOne-Regular", size: 16))
                                                                .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255))
                                                        }
                                                        Spacer()
                                                    }
                                                }
                                            }
                                    }
                                    .frame(height: 120)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top, 15)
                }
            }
            .padding(.top)
        }
    }
}

#Preview {
    ProfileView()
}

