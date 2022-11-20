//
//  MarketplaceDetailsView.swift
//  App
//
//  Created by Atharva Mathapati on 19.11.22.
//

import SwiftUI

struct MarketplaceCardDetailsView: View {
    let card: Card
    @StateObject private var viewModel = MarketplaceCardDetailsViewModel()
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    
    var body: some View {
        let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                HStack(alignment: .top, spacing: 4) {
                    AsyncImage(url: card.imageUrl, transaction: Transaction(animation: .default)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 209.4)
                                .padding(.trailing, 15)
                        default:
                            Color.gray
                                .frame(width: 150, height: 209.4)
                                .cornerRadius(8)
                                .padding(.trailing, 15)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: .zero) {
                        Spacer()
                        
                        Text(card.name)
                            .font(.largeTitle)
                            .bold()
                        
                        Spacer()
                        
                        Text(card.rarity?.rawValue ?? "Unknown")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .bold()
                            .padding(.bottom, 2)
                            .foregroundColor(.secondary)
                        
                        Group {
                            if let owned = viewModel.owned {
                                Text("Owned: \(owned)")
                            } else {
                                Text("Owned: -")
                                    .task {
                                        await viewModel.fetchOwnedCount(cardId: card.id, userId: authenticationManager.user.id)
                                    }
                            }
                        }
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .bold()
                        .padding(.bottom, 2)
                        .foregroundColor(.secondary)
                        
                        Group {
                            if let recommendedPrice = viewModel.recommendedPrice {
                                Text("Price: \(recommendedPrice.formatted(.currency(code: "USD")))")
                            } else {
                                Text("Price: -")
                                    .task {
                                        await viewModel.fetchRecommendedPrice(cardId: card.id)
                                    }
                            }
                        }
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .bold()
                        .padding(.bottom, 2)
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer(minLength: .zero)
                }
                .frame(height: 209.4)
                
                HStack (spacing: 20) {
                    Button {
                        viewModel.orderSide = .buy
                    } label: {
                        Text("Buy")
                            .fontWeight(.bold)
                            .foregroundColor(.bbBlack)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.green)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        viewModel.orderSide = .sell
                    } label: {
                        Text("Sell")
                            .fontWeight(.bold)
                            .foregroundColor(.bbBlack)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.bbRed)
                            .cornerRadius(10)
                    }
                }
                
                VStack(spacing: 20) {
                    if let buyOrders = viewModel.buy, let sellOrders = viewModel.sell {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Buy Requests")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Group {
                                if buyOrders.isEmpty {
                                    Text("No buy orders.")
                                } else {
                                    ForEach(buyOrders) { buyOrder in
                                        PendingCardOrderRow(order: buyOrder)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sell Offers")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Group {
                                if sellOrders.isEmpty {
                                    Text("No sell orders.")
                                } else {
                                    ForEach(sellOrders) { sellOrder in
                                        PendingCardOrderRow(order: sellOrder)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    } else {
                        ProgressView("Loading...")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .task {
                                await viewModel.fetchOrders(cardId: card.id)
                            }
                    }
                }
                .animation(.default, value: viewModel.buy)
                .animation(.default, value: viewModel.sell)
                
                Spacer(minLength: .zero)
            }
            .sheet(item: $viewModel.orderSide) {
                viewModel.buy = nil
                viewModel.sell = nil
                viewModel.owned = nil
                viewModel.recommendedPrice = nil
            } content: { side in
                OrderSheetView(side: side, cardId: card.id)
            }
            .onReceive(timer) { _ in
                Task {
                    await viewModel.fetchOwnedCount(cardId: card.id, userId: authenticationManager.user.id)
                    await viewModel.fetchRecommendedPrice(cardId: card.id)
                    await viewModel.fetchOrders(cardId: card.id)
                }
            }
            .padding(20)
            .navigationTitle(Text("Card Shop"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MarketplaceCardDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MarketplaceCardDetailsView(card: Card(id: "abc", name: "Pikachu", rarity: .amazingRare, imageUrl: URL(string: "https://images.pokemontcg.io/xy1/1.png")!))
    }
}
