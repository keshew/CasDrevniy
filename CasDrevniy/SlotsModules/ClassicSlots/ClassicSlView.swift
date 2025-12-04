import SwiftUI

struct ClassicSlView: View {
    @StateObject var viewModel =  ClassicSlViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                        Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                Image("slot3Bg").resizable().ignoresSafeArea()
                
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                                      Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom))
                        .frame(height: UIScreen.main.bounds.width > 1000 ? 95 : 65)
                    
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
                                        
                                        Text("\(viewModel.coin)")
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
                .padding(.top,  UIScreen.main.bounds.width > 1000 ? 15 : 0)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        Rectangle()
                            .fill(Color(red: 65/255, green: 0/255, blue: 2/255).opacity(0.95))
                            .frame(width: 450, height: 250)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 255/255, green: 0/255, blue: 4/255), lineWidth: 2)
                                    .overlay {
                                        VStack(spacing: 15) {
                                            VStack(spacing: 5) {
                                                ForEach(0..<3, id: \.self) { row in
                                                    HStack(spacing: 0) {
                                                        ForEach(0..<5, id: \.self) { col in
                                                            Rectangle()
                                                                .fill(
                                                                    LinearGradient(
                                                                        colors: [Color.black.opacity(0.2)],
                                                                        startPoint: .topLeading,
                                                                        endPoint: .bottomTrailing
                                                                    )
                                                                )
                                                                .overlay {
                                                                    RoundedRectangle(cornerRadius: 14)
                                                                        .stroke(Color.white.opacity(0.3), lineWidth: 3)
                                                                        .overlay(
                                                                            Image(viewModel.slots[row][col])
                                                                                .resizable()
                                                                                .aspectRatio(contentMode: .fit)
                                                                                .frame(width: 40, height: 40)
                                                                        )
                                                                }
                                                                .frame(width: 50, height: 50)
                                                                .cornerRadius(14)
                                                                .padding(.horizontal, 5)
                                                                .shadow(
                                                                    color: viewModel.winningPositions.contains(where: { $0.row == row && $0.col == col }) ? Color.yellow : .clear,
                                                                    radius: viewModel.isSpinning ? 0 : 25
                                                                )
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            HStack {
                                                HStack(spacing: 20) {
                                                    Button(action: {
                                                        if viewModel.bet >= 5 {
                                                            viewModel.bet -= 5
                                                        }
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
                                                            .font(.custom("PaytoneOne-Regular", size: 12))
                                                            .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                        
                                                        Text("\(viewModel.bet)")
                                                            .font(.custom("PaytoneOne-Regular", size: 20))
                                                            .foregroundStyle(.white)
                                                    }
                                                    
                                                    Button(action: {
                                                        if viewModel.bet <= (viewModel.coin - 5) {
                                                            viewModel.bet += 5
                                                        }
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
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    if viewModel.coin >= viewModel.bet {
                                                        viewModel.spin()
                                                    }
                                                }) {
                                                    Rectangle()
                                                        .fill(Color(red: 255/255, green: 0/255, blue: 0/255))
                                                        .overlay {
                                                            HStack {
                                                                Image(systemName: "play")
                                                                    .foregroundStyle(.white)
                                                                
                                                                Text("SPIN")
                                                                    .font(.custom("PaytoneOne-Regular", size: 18))
                                                                    .foregroundStyle(.white)
                                                            }
                                                        }
                                                        .frame(width: 129, height: 32)
                                                        .cornerRadius(6)
                                                }
                                                .disabled(viewModel.isSpinning)
                                                .shadow(color: Color(red: 169/255, green: 1/255, blue: 255/255), radius: 15)
                                            }
                                            .padding(.horizontal, 15)
                                        }
                                    }
                            }
                            .cornerRadius(12)
                        
                        Rectangle()
                            .fill(Color.black.opacity(0.5))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 169/255, green: 1/255, blue: 255/255).opacity(0.3), lineWidth: 3)
                                    .overlay {
                                        HStack {
                                            Spacer()
                                            VStack {
                                                Text("Spins")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                
                                                Text("\(UserDefaultsManager.shared.getGamesPlayed(forGame: 1))")
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(Color.white)
                                            }
                                            Spacer()
                                            VStack {
                                                Text("Total Wins")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                
                                                Text("\(UserDefaultsManager.shared.getWins(forGame: 1))")
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(Color(red: 2/255, green: 255/255, blue: 128/255))
                                            }
                                            Spacer()
                                            VStack {
                                                Text("Biggest Win")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                
                                                Text("\(UserDefaultsManager.shared.getMaxWin(forGame: 1))")
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(Color(red: 169/255, green: 1/255, blue: 255/255))
                                            }
                                            Spacer()
                                            
                                            VStack {
                                                Text("Win Rate")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                
                                                Text(String(format: "%.1f%%", UserDefaultsManager.shared.getWinPercentage(forGame: 1)))
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(Color.white)
                                            }
                                            Spacer()
                                        }
                                    }
                            }
                            .frame(width: 450, height: 50)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.top, 15)
                }
            }
            .padding(.top)
        }
    }
}

#Preview {
    ClassicSlView()
}

