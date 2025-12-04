import SwiftUI

struct CoinGameView: View {
    @StateObject var viewModel =  CoinGameViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                        Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                Image("coinBg").resizable().ignoresSafeArea()
                
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
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        Rectangle()
                            .fill(Color(red: 20/255, green: 20/255, blue: 31/255).opacity(0.95))
                            .frame(width: 450, height: 250)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 169/255, green: 1/255, blue: 255/255).opacity(0.3), lineWidth: 2)
                                    .overlay {
                                        VStack(spacing: 15) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color(red: 202/255, green: 138/255, blue: 4/255))
                                                    .frame(width: 95, height: 95)
                                                
                                                Circle()
                                                    .fill(LinearGradient(colors: [Color(red: 250/255, green: 204/255, blue: 22/255),
                                                                                  Color(red: 249/255, green: 115/255, blue: 23/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                    .frame(width: 85, height: 85)
                                                
                                                Image(viewModel.rotationStep % 2 == 0 ? "head" : "trail")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 60, height: 60)
                                            }
                                            .rotation3DEffect(
                                                .degrees(Double(viewModel.rotationStep) * 360.0 / 2),
                                                axis: (x: 0, y: 1, z: 0)
                                            )
                                            .animation(.easeInOut(duration: 0.1), value: viewModel.rotationStep)
                                            
                                            HStack {
                                                Button(action: {
                                                    withAnimation {
                                                        viewModel.isTail = false
                                                    }
                                                }) {
                                                    Rectangle()
                                                        .fill(viewModel.isTail ? Color(red: 31/255, green: 31/255, blue: 46/255) : Color(red: 166/255, green: 0/255, blue: 249/255))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(Color(red: 31/255, green: 31/255, blue: 46/255), lineWidth: viewModel.isTail ? 0 : 2)
                                                                .overlay {
                                                                    HStack(spacing: 3) {
                                                                        Image("head")
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fit)
                                                                            .frame(width: 18, height: 18)
                                                                        
                                                                        Text("Heads")
                                                                            .font(.custom("PaytoneOne-Regular", size: 14))
                                                                            .foregroundStyle(.white)
                                                                            .offset(y: -1)
                                                                    }
                                                                }
                                                        }
                                                        .frame(width: 93, height: 25)
                                                        .cornerRadius(8)
                                                }
                                                
                                                Button(action: {
                                                    withAnimation {
                                                        viewModel.isTail = true
                                                    }
                                                }) {
                                                    Rectangle()
                                                        .fill(!viewModel.isTail ? Color(red: 31/255, green: 31/255, blue: 46/255) : Color(red: 166/255, green: 0/255, blue: 249/255))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(Color(red: 31/255, green: 31/255, blue: 46/255), lineWidth: !viewModel.isTail ? 0 : 2)
                                                                .overlay {
                                                                    HStack(spacing: 3) {
                                                                        Image("trail")
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fit)
                                                                            .frame(width: 18, height: 18)
                                                                        
                                                                        Text("Tails")
                                                                            .font(.custom("PaytoneOne-Regular", size: 14))
                                                                            .foregroundStyle(.white)
                                                                            .offset(y: -1)
                                                                    }
                                                                }
                                                        }
                                                        .frame(width: 93, height: 25)
                                                        .cornerRadius(8)
                                                }
                                            }
                                            
                                            HStack(spacing: 20) {
                                                Button(action: {
                                                    if viewModel.bet >= 100 {
                                                        viewModel.bet -= 50
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
                                                        .font(.custom("PaytoneOne-Regular", size: 10))
                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                    
                                                    Text("\(viewModel.bet)")
                                                        .font(.custom("PaytoneOne-Regular", size: 18))
                                                        .foregroundStyle(.white)
                                                }
                                                
                                                Button(action: {
                                                    if (viewModel.bet + 50) <= viewModel.coin {
                                                        viewModel.bet += 50
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
                                            
                                            Button(action: {
                                                withAnimation {
                                                    viewModel.startFlip(userChoice: viewModel.isTail)
                                                   }
                                            }) {
                                                Rectangle()
                                                    .fill(Color(red: 255/255, green: 191/255, blue: 1/255))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .stroke(Color(red: 171/255, green: 0/255, blue: 255/255), lineWidth: 2)
                                                            .overlay {
                                                                Text("FLIP COIN")
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
                        
                        Rectangle()
                            .fill(Color.black.opacity(0.5))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 169/255, green: 1/255, blue: 255/255).opacity(0.3), lineWidth: 3)
                                    .overlay {
                                        HStack {
                                            Spacer()
                                            VStack {
                                                Text("Total Plays")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                
                                                Text("\(UserDefaultsManager.shared.getGamesPlayed(forGame: 6))")
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(Color.white)
                                            }
                                            Spacer()
                                            VStack {
                                                Text("Total Wins")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                
                                                Text("\(UserDefaultsManager.shared.getWins(forGame: 6))")
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(Color(red: 2/255, green: 255/255, blue: 128/255))
                                            }
                                            Spacer()
                                            VStack {
                                                Text("Biggest Win")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                
                                                Text("\(UserDefaultsManager.shared.getMaxWin(forGame: 6))")
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(Color(red: 169/255, green: 1/255, blue: 255/255))
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
    CoinGameView()
}

