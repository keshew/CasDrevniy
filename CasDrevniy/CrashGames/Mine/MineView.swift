import SwiftUI

struct MineView: View {
    @StateObject var viewModel =  MineViewModel()
    let columns = Array(repeating: GridItem(.fixed(40), spacing: 0), count: 5)
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                LinearGradient(colors: [Color(red: 10/255, green: 10/255, blue: 15/255),
                                        Color(red: 18/255, green: 18/255, blue: 33/255)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                Image("minesBg").resizable().ignoresSafeArea()
                
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
                                        
                                        Text("\(viewModel.balance)")
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
                                    .stroke(Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.3), lineWidth: 2)
                                    .overlay {
                                        VStack(spacing: 0) {
                                            VStack(spacing: 0) {
                                                Text("Current Mulriplier")
                                                    .font(.custom("PaytoneOne-Regular", size: 12))
                                                    .foregroundStyle(Color(red: 179/255, green: 179/255, blue: 179/255))
                                                
                                                Text("1.00x")
                                                    .font(.custom("PaytoneOne-Regular", size: 18))
                                                    .foregroundStyle(.white)
                                            }
                                            
                                            VStack(spacing: 10) {
                                                LazyVGrid(columns: columns, spacing: 6) {
                                                    ForEach(viewModel.cards.indices, id: \.self) { index in
                                                        let card = viewModel.cards[index]
                                                        Button(action: {
                                                            viewModel.openCard(at: index)
                                                        }) {
                                                            if card.isOpened {
                                                                Rectangle()
                                                                    .fill(
                                                                        LinearGradient(
                                                                            colors: card.isBomb
                                                                            ? [Color.red.opacity(0.8), Color.red.opacity(0.6)]
                                                                            : [Color.green.opacity(0.7), Color.green.opacity(0.4)],
                                                                            startPoint: .topLeading,
                                                                            endPoint: .bottomTrailing
                                                                        )
                                                                    )
                                                                    .overlay {
                                                                        RoundedRectangle(cornerRadius: 6)
                                                                            .stroke(
                                                                                card.isBomb
                                                                                ? Color.red.opacity(0.9)
                                                                                : Color.green.opacity(0.9),
                                                                                lineWidth: 3
                                                                            )
                                                                            .overlay(
                                                                                Image(card.image)
                                                                                    .resizable()
                                                                                    .aspectRatio(contentMode: .fit)
                                                                                    .frame(width: 30, height: 30)
                                                                            )
                                                                    }
                                                                    .frame(width: 33, height: 33)
                                                                    .cornerRadius(6)
                                                                    .padding(.horizontal, 5)
                                                                    .shadow(
                                                                        color: card.isBomb
                                                                        ? Color.red.opacity(0.8)
                                                                        : Color.green.opacity(0.7),
                                                                        radius: 10
                                                                    )
                                                            } else {
                                                                Rectangle()
                                                                    .fill(
                                                                        LinearGradient(
                                                                            colors: [Color.white.opacity(0.2), Color.white.opacity(0.1)],
                                                                            startPoint: .topLeading,
                                                                            endPoint: .bottomTrailing
                                                                        )
                                                                    )
                                                                    .overlay(
                                                                        RoundedRectangle(cornerRadius: 8)
                                                                            .stroke(Color.white.opacity(0.3), lineWidth: 3)
                                                                    )
                                                                    .frame(width: 33, height: 33)
                                                                    .cornerRadius(8)
                                                                    .padding(.horizontal, 5)
                                                            }
                                                        }
                                                        .disabled(card.isOpened || !viewModel.isPlaying)
                                                    }
                                                }
                                                .padding()
                                                .disabled(!viewModel.isPlaying)
                                            }
                                            
                                            Button(action: {
                                                if viewModel.isPlaying {
                                                    viewModel.getReward()
                                                } else {
                                                    viewModel.startGame()
                                                }
                                            }) {
                                                Rectangle()
                                                    .fill(Color(red: 2/255, green: 255/255, blue: 128/255))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .stroke(Color(red: 171/255, green: 0/255, blue: 255/255), lineWidth: 2)
                                                            .overlay {
                                                                Text(viewModel.isPlaying ? "CLAIM" : "START")
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
    MineView()
}

