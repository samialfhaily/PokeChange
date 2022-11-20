//
//  MarketplaceDetailsView.swift
//  App
//
//  Created by Atharva Mathapati on 19.11.22.
//

import SwiftUI

struct CountResponse: Codable {
    let count: Int
}

struct PriceResponse: Codable {
    let price: Int?
}

struct ActiveOrdersResponse: Codable {
    let buy: [MasterOrder]
    let sell: [MasterOrder]
}

final class MarketplaceCardDetailsViewModel: ObservableObject {
    @Published var buy: [MasterOrder]?
    @Published var sell: [MasterOrder]?
    @Published var orderSide: Side?
    @Published var owned: Int?
    @Published var recommendedPrice: Int?
    
    @MainActor func fetchOrders(cardId: String) async {
        let url = URL(string: "https://andreascs.com/api/cards/\(cardId)/orders")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            decoder.dateDecodingStrategy = Foundation.JSONDecoder.DateDecodingStrategy.formatted(formatter)
            let response = try decoder.decode(ActiveOrdersResponse.self, from: data)
            self.buy = response.buy
            self.sell = response.sell
        } catch {
            self.buy = []
            self.sell = []
            print(error.localizedDescription)
        }
    }
    
    @MainActor func fetchOwnedCount(cardId: String, userId: Int) async {
        let url = URL(string: "https://andreascs.com/api/user/\(userId)/card/\(cardId)/count")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(CountResponse.self, from: data)
            self.owned = response.count
        } catch {
            self.owned = 0
            print(error.localizedDescription)
        }
    }
    
    @MainActor func fetchRecommendedPrice(cardId: String) async {
        let url = URL(string: "https://andreascs.com/api/cards/\(cardId)/price")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(PriceResponse.self, from: data)
            self.recommendedPrice = response.price
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct MarketplaceCardDetailsView: View {
    let card: Card
    @StateObject private var viewModel = MarketplaceCardDetailsViewModel()
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    
    var body: some View {
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
                            Text("Price: \(recommendedPrice)")
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
        .padding(20)
        .navigationTitle(Text("Card Shop"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PendingCardOrderRow: View {
    let order: MasterOrder
    
    var body: some View {
        HStack {
            Group {
                Spacer(minLength: .zero)
                Text(order.quantity, format: .number)
                Spacer(minLength: .zero)
                Divider()
                Spacer(minLength: .zero)
                Text(order.price, format: .currency(code: "USD"))
            }
            Group {
                Spacer(minLength: .zero)
                Divider()
                Spacer(minLength: .zero)
                Text(order.username)
                Spacer(minLength: .zero)
            }
        }
        .frame(height: 30)
    }
}

struct PendingCardOrderRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 12) {
            PendingCardOrderRow(order: MasterOrder(
                id: 2,
                card: Card(id: "abc", name: "Pikachu", rarity: .amazingRare, imageUrl: URL(string: "https://images.pokemontcg.io/xy1/1.png")!),
                quantity: 1,
                price: 10,
                side: .sell,
                username: "atharva",
                completed: true,
                placeDate: .now
            )
            )
            PendingCardOrderRow(order: MasterOrder(
                id: 2,
                card: Card(id: "abc", name: "Pikachu", rarity: .amazingRare, imageUrl: URL(string: "https://images.pokemontcg.io/xy1/1.png")!),
                quantity: 1,
                price: 10,
                side: .sell,
                username: "atharva",
                completed: true,
                placeDate: .now
            )
            )
        }
    }
}

struct MarketplaceCardDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MarketplaceCardDetailsView(card: Card(id: "abc", name: "Pikachu", rarity: .amazingRare, imageUrl: URL(string: "https://images.pokemontcg.io/xy1/1.png")!))
    }
}
