//
//  MarketplaceDetailsView.swift
//  App
//
//  Created by Atharva Mathapati on 19.11.22.
//

import SwiftUI

struct ActiveOrdersResponse: Codable {
    let buy: [MasterOrder]
    let sell: [MasterOrder]
}

final class MarketplaceCardDetailsViewModel: ObservableObject {
    @Published var buy: [MasterOrder]?
    @Published var sell: [MasterOrder]?
    
    @MainActor func fetchOrders(cardId: String) async {
        let url = URL(string: "https://andreascs.com/api/cards/\(cardId)/orders")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(ActiveOrdersResponse.self, from: data)
            self.buy = response.buy
            self.sell = response.sell
        } catch {
            self.buy = []
            self.sell = []
            print(error.localizedDescription)
        }
    }
}

struct MarketplaceCardDetailsView: View {
    let card: Card
    @StateObject private var viewModel = MarketplaceCardDetailsViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .bottom, spacing: 4) {
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
                    Text(card.name)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(card.rarity?.rawValue ?? "Unknown")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .bold()
                        .padding(.bottom, 2)
                        .foregroundColor(.secondary)
                    Text("Owned: 5")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .bold()
                        .padding(.bottom, 2)
                        .foregroundColor(.secondary)
                }
                
                Spacer(minLength: .zero)
            }
            
            Group {
                if let buyOrders = viewModel.buy, let sellOrders = viewModel.sell {
                    VStack(alignment: .leading, spacing: 8) {
                        VStack(alignment: .leading) {
                            Text("Buy Requests")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Group {
                                if buyOrders.isEmpty {
                                    Text("No buy orders.")
                                } else {
                                    ForEach(buyOrders) { buyOrder in
                                        Text(buyOrder.price, format: .currency(code: "USD"))
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                    }
                    VStack(alignment: .leading) {
                        Text("Sell Offers")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Group {
                            if sellOrders.isEmpty {
                                Text("No sell orders.")
                            } else {
                                ForEach(sellOrders) { sellOrder in
                                    Text(sellOrder.price, format: .currency(code: "USD"))
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
            
            HStack (spacing: 20) {
                Button {
                    
                } label: {
                    Text("Sell")
                        .fontWeight(.bold)
                        .foregroundColor(.bbBlack)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .background(Color.green))
                        .cornerRadius(10)
                }
                
                Button {
                } label: {
                    Text("Buy")
                        .fontWeight(.bold)
                        .foregroundColor(.bbBlack)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .background(Color.bbRed))
                        .cornerRadius(10)
                }
            }
            
            Spacer(minLength: .zero)
        }
        .padding(20)
        .navigationTitle(Text("Card Shop"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MarketplaceCardDetailsView_Previews: PreviewProvider {
    static let card = Card(id: "abc", name: "Pikachu", rarity: .amazingRare, imageUrl: URL(string: "https://images.pokemontcg.io/xy1/1.png")!)
    static var previews: some View {
        MarketplaceCardDetailsView(card: card)
    }
}
