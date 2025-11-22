import SwiftUI

struct DiceView: View {
    @StateObject var viewModel =  DiceViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                        Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                Image("diceBg").resizable().ignoresSafeArea()
                
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
                            .frame(width: 450, height: 310)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 169/255, green: 1/255, blue: 255/255).opacity(0.3), lineWidth: 2)
                                    .overlay {
                                        VStack(spacing: 10) {
                                            VStack {
                                                HStack(spacing: 15) {
                                                    Rectangle()
                                                        .fill(LinearGradient(colors: [Color(red: 248/255, green: 113/255, blue: 113/255),
                                                                                      Color(red: 236/255, green: 72/255, blue: 153/255)], startPoint: .top, endPoint: .bottom))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .stroke(Color(red: 220/255, green: 38/255, blue: 38/255), lineWidth: 3)
                                                                .overlay {
                                                                    Image("dice\(viewModel.dice1Value)")
                                                                        .resizable()
                                                                        .frame(width: 45, height: 45)
                                                                        .rotationEffect(.degrees(viewModel.dice1Rotation))
                                                                        .animation(.easeInOut, value: viewModel.dice1Rotation)
                                                                }
                                                        }
                                                        .frame(width: 70, height: 70)
                                                        .cornerRadius(12)
                                                    
                                                    Rectangle()
                                                        .fill(LinearGradient(colors: [Color(red: 248/255, green: 113/255, blue: 113/255),
                                                                                      Color(red: 236/255, green: 72/255, blue: 153/255)], startPoint: .top, endPoint: .bottom))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .stroke(Color(red: 220/255, green: 38/255, blue: 38/255), lineWidth: 3)
                                                                .overlay {
                                                                    Image("dice\(viewModel.dice2Value)")
                                                                        .resizable()
                                                                        .frame(width: 45, height: 45)
                                                                        .rotationEffect(.degrees(viewModel.dice2Rotation))
                                                                        .animation(.easeInOut, value: viewModel.dice2Rotation)
                                                                }
                                                        }
                                                        .frame(width: 70, height: 70)
                                                        .cornerRadius(12)
                                                }
                                                
                                                Text("Total")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                    .offset(y: -1)
                                                
                                                Text("\(viewModel.diceTotal)")
                                                    .font(.custom("PaytoneOne-Regular", size: 18))
                                                    .foregroundStyle(.white)
                                                    .offset(y: -1)
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
                                                viewModel.rollBothDiceWithAnimation()
                                            }) {
                                                Rectangle()
                                                    .fill(Color(red: 255/255, green: 191/255, blue: 1/255))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .stroke(Color(red: 171/255, green: 0/255, blue: 255/255), lineWidth: 2)
                                                            .overlay {
                                                                Text("ROLL DICE")
                                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                                    .foregroundStyle(.white)
                                                            }
                                                    }
                                                    .frame(width: 109, height: 26)
                                                    .cornerRadius(6)
                                            }
                                            
                                            Rectangle()
                                                .fill(Color(red: 31/255, green: 31/255, blue: 46/255).opacity(0.5))
                                                .frame(width: 400, height: 70)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color(red: 169/255, green: 1/255, blue: 255/255), lineWidth: 2)
                                                        .overlay {
                                                            VStack {
                                                                HStack {
                                                                    Text("Double 6s")
                                                                        .font(.custom("PaytoneOne-Regular", size: 10))
                                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                                    
                                                                    Spacer()
                                                                    
                                                                    Text("10x")
                                                                        .font(.custom("PaytoneOne-Regular", size: 10))
                                                                        .foregroundStyle(Color(red: 169/255, green: 1/255, blue: 255/255))
                                                                }
                                                                
                                                                HStack {
                                                                    Text("Any Double")
                                                                        .font(.custom("PaytoneOne-Regular", size: 10))
                                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                                    
                                                                    Spacer()
                                                                    
                                                                    Text("5x")
                                                                        .font(.custom("PaytoneOne-Regular", size: 10))
                                                                        .foregroundStyle(Color(red: 2/255, green: 255/255, blue: 128/255))
                                                                }
                                                                
                                                                HStack {
                                                                    Text("7 or 11")
                                                                        .font(.custom("PaytoneOne-Regular", size: 10))
                                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                                    
                                                                    Spacer()
                                                                    
                                                                    Text("3x")
                                                                        .font(.custom("PaytoneOne-Regular", size: 10))
                                                                        .foregroundStyle(Color(red: 2/255, green: 255/255, blue: 128/255))
                                                                }
                                                                
                                                                HStack {
                                                                    Text("9 or higher")
                                                                        .font(.custom("PaytoneOne-Regular", size: 10))
                                                                        .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                                    
                                                                    Spacer()
                                                                    
                                                                    Text("2x")
                                                                        .font(.custom("PaytoneOne-Regular", size: 10))
                                                                        .foregroundStyle(Color.white)
                                                                }
                                                            }
                                                            .padding(.horizontal)
                                                        }
                                                }
                                                .cornerRadius(12)
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
    DiceView()
}

