import SwiftUI

struct AviatorView: View {
    @StateObject var viewModel =  AviatorViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                        Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                Image("aviatorbg").resizable().ignoresSafeArea()
                
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
                                    .stroke(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.3), lineWidth: 2)
                                    .overlay {
                                        VStack(spacing: 15) {
                                            ZStack(alignment: .bottomLeading) {
                                                ZStack(alignment: .top) {
                                                    Rectangle()
                                                        .fill(LinearGradient(colors: [Color(red: 30/255, green: 58/255, blue: 137/255),
                                                                                      .black], startPoint: .top, endPoint: .bottom))
                                                        .frame(width: 390, height: 170)
                                                        .cornerRadius(16)
                                                    
                                                    Text(viewModel.multiplierString)
                                                       .font(.custom("PaytoneOne-Regular", size: 34))
                                                       .foregroundStyle(.white)
                                                }
                                                
                                                Image("rocket")
                                                    .resizable()
                                                    .frame(width: 36, height: 36)
                                                    .padding(10)
                                                    .offset(x: viewModel.planePositionX, y: viewModel.planePositionY)
                                                    .rotationEffect(Angle(degrees: viewModel.planeRotation))
                                            }
                                            
                                            Button(action: {
                                                withAnimation {
                                                    if !viewModel.isPlaying {
                                                        viewModel.startGame()
                                                    } else {
                                                        viewModel.collectReward()
                                                    }
                                                   }
                                            }) {
                                                Rectangle()
                                                    .fill(Color(red: 2/255, green: 255/255, blue: 128/255))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .stroke(Color(red: 171/255, green: 0/255, blue: 255/255), lineWidth: 2)
                                                            .overlay {
                                                                Text(viewModel.isPlaying ? "GET" : "START")
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
                                    .stroke(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.3), lineWidth: 3)
                                    .overlay {
                                        HStack {
                                            Spacer()
                                            VStack {
                                                Text("Total Plays")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                
                                                Text("\(UserDefaultsManager.shared.getGamesPlayed(forGame: 5))")
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(Color.white)
                                            }
                                            Spacer()
                                            VStack {
                                                Text("Total Wins")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                
                                                Text("\(UserDefaultsManager.shared.getWins(forGame: 5))")
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(Color(red: 2/255, green: 255/255, blue: 128/255))
                                            }
                                            Spacer()
                                            VStack {
                                                Text("Biggest Win")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                
                                                Text("\(UserDefaultsManager.shared.getMaxWin(forGame: 5))")
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
    AviatorView()
}

