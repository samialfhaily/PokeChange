//
//  MarketplaceCardDetailsViewModel.swift
//  App
//
//  Created by Sami Alfhaily on 20.11.22.
//

import Foundation

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
