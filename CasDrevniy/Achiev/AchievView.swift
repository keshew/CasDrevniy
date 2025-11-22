import SwiftUI

struct Achiev: Identifiable, Codable {
    var id = UUID()
    var name: String
    var desc: String
    var goal: Int
    var currentGoal: Int
    var isUnlocked: Bool {
        currentGoal >= goal
    }
}

struct AchievView: View {
    @StateObject var achievModel =  AchievViewModel()
    let gridSlot = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Environment(\.presentationMode) var presentationMode
    @State var acbiev = [Achiev(name: "First Spin", desc: "Complete your first spin", goal: 1, currentGoal: 0),
                  Achiev(name: "Spin Master", desc: "Complete 100 spins", goal: 100, currentGoal: 0),
                  Achiev(name: "First Win", desc: "Win your first game", goal: 1, currentGoal: 0),
                  Achiev(name: "Big Winner", desc: "Win 10,000 coins in a single spin", goal: 10000, currentGoal: 0),
                  Achiev(name: "Coin Collector", desc: "Accumulate 50,000 coins", goal: 50000, currentGoal: 0)]
//                  Achiev(name: "Lucky Seven", desc: "Win 7 times in a row", goal: 7, currentGoal: 0),
//                  Achiev(name: "Instant Master", desc: "Play 50 instant games", goal: 50, currentGoal: 0),
//                  Achiev(name: "High Roller", desc: "Bet 10,000 coins in total", goal: 10000, currentGoal: 0)]
    
    @State var coins = UserDefaultsManager.shared.coins
    @State var isProfile = false
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                        Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                Image("achevBg").resizable().ignoresSafeArea()
                
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
                        
                        HStack {
                            Image("achiev2")
                                .resizable()
                                .frame(width: 16, height: 16)
                            
                            Text("Achievements")
                                .font(.custom("PaytoneOne-Regular", size: 14))
                                .foregroundStyle(Color.black)
                             
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(Color(red: 255/255, green: 215/255, blue: 0/255))
                        .cornerRadius(8)
                        .shadow(color: .purple, radius: 10)
                        
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
                            Text("ACHIEVEMENTS")
                                .font(.custom("PaytoneOne-Regular", size: 35))
                                .foregroundStyle(Color(red: 255/255, green: 215/255, blue: 0/255))
                                .shadow(color: Color(red: 169/255, green: 1/255, blue: 255/255), radius: 10)
                            
                            Text("Track your progress and unlock rewards")
                                .font(.custom("PaytoneOne-Regular", size: 14))
                                .foregroundStyle(Color(red: 255/255, green: 240/255, blue: 179/255))
                        }
                        
                        
                        Rectangle()
                            .fill(LinearGradient(colors: [Color(red: 255/255, green: 215/255, blue: 0/255),
                                                          Color(red: 255/255, green: 0/255, blue: 170/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.3), lineWidth: 3)
                                    .overlay {
                                        VStack(spacing: 10) {
                                            let totalAchievements = acbiev.count
                                            let unlockedAchievements = acbiev.filter { $0.isUnlocked }.count
                                            let completionRate = totalAchievements > 0 ? (Double(unlockedAchievements) / Double(totalAchievements)) * 100 : 0.0

                                            VStack(spacing: 10) {
                                                Text("Completion Rate")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(.white.opacity(0.8))

                                                Text(String(format: "%.0f%%", completionRate))
                                                    .font(.custom("PaytoneOne-Regular", size: 35))
                                                    .foregroundStyle(.white)

                                                Text("\(unlockedAchievements) of \(totalAchievements) unlocked")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(.white.opacity(0.8))
                                            }
                                        }
                                    }
                            }
                            .frame(width: 150, height: 150)
                            .cornerRadius(12)
                        
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
                            
                            LazyVGrid(columns: gridSlot, spacing: 20) {
                                ForEach(acbiev, id: \.id) { achiv in
                                    if achiv.isUnlocked {
                                        Rectangle()
                                            .fill(LinearGradient(colors: [Color.black,
                                                                          Color(red: 2/255, green: 255/255, blue: 128/255).opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color(red: 2/255, green: 255/255, blue: 128/255), lineWidth: 2)
                                                    .overlay {
                                                        HStack {
                                                            VStack(alignment: .leading, spacing: 20) {
                                                                Circle()
                                                                    .fill(LinearGradient(colors: [Color(red: 255/255, green: 215/255, blue: 0/255),
                                                                                                  Color(red: 255/255, green: 0/255, blue: 170/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                                    .frame(width: 64, height: 64)
                                                                    .overlay {
                                                                        Image("champ")
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fit)
                                                                            .frame(width: 48, height: 48)
                                                                    }
                                                                
                                                                VStack(alignment: .leading, spacing: 10) {
                                                                    Text(achiv.name)
                                                                        .font(.custom("PaytoneOne-Regular", size: 16))
                                                                        .foregroundStyle(.white)
                                                                    
                                                                    Text(achiv.desc)
                                                                        .font(.custom("PaytoneOne-Regular", size: 12))
                                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                                    
                                                                    HStack {
                                                                        Image("achived")
                                                                            .resizable()
                                                                            .frame(width: 20, height: 20)
                                                                        
                                                                        Text("Unlocked!")
                                                                            .font(.custom("PaytoneOne-Regular", size: 16))
                                                                            .foregroundStyle(Color(red: 2/255, green: 255/255, blue: 128/255))
                                                                    }
                                                                }
                                                            }
                                                            .padding(.horizontal, 20)
                                                            .padding(.vertical)
                                                            
                                                            Spacer()
                                                        }
                                                    }
                                            }
                                            .frame(width: 240, height: 190)
                                            .cornerRadius(12)
                                    } else {
                                        ZStack(alignment: .topTrailing) {
                                            Rectangle()
                                                .fill(.black.opacity(0.5))
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color.black, lineWidth: 2)
                                                        .overlay {
                                                            VStack(alignment: .leading, spacing: 20) {
                                                                Image("champ")
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
                                                                    .frame(width: 48, height: 48)
                                                                
                                                                VStack(alignment: .leading, spacing: 10) {
                                                                    Text(achiv.name)
                                                                        .font(.custom("PaytoneOne-Regular", size: 16))
                                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                                    
                                                                    Text(achiv.desc)
                                                                        .font(.custom("PaytoneOne-Regular", size: 12))
                                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                                    
                                                                    VStack(spacing: 5) {
                                                                        HStack {
                                                                            Text("Progress")
                                                                                .font(.custom("PaytoneOne-Regular", size: 12))
                                                                                .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                                            
                                                                            Spacer()
                                                                            
                                                                            Text("\(achiv.currentGoal)/\(achiv.goal)")
                                                                                .font(.custom("PaytoneOne-Regular", size: 12))
                                                                                .foregroundStyle(Color.white)
                                                                        }
                                                                        
                                                                        GeometryReader { geometry in
                                                                            let progress = CGFloat(achiv.currentGoal) / CGFloat(achiv.goal)
                                                                            let totalWidth = geometry.size.width
                                                                            let progressWidth = totalWidth * progress
                                                                            
                                                                            ZStack(alignment: .leading) {
                                                                                Rectangle()
                                                                                    .fill(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.2))
                                                                                    .frame(width: totalWidth, height: 8)
                                                                                    .cornerRadius(10)
                                                                                
                                                                                Rectangle()
                                                                                    .fill(Color(red: 255/255, green: 215/255, blue: 0/255))
                                                                                    .frame(width: progressWidth, height: 8)
                                                                                    .cornerRadius(10)
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            .padding()
                                                        }
                                                }
                                                .frame(width: 240, height: 190)
                                                .cornerRadius(12)
                                            
                                            Image("lock")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 24, height: 24)
                                                .offset(x: -15, y: 15)
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
        .fullScreenCover(isPresented: $isProfile) {
            ProfileView()
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
    AchievView()
}

