//
//  WalletViewModel.swift
//  App
//
//  Created by Sami Alfhaily on 20.11.22.
//

import Foundation

struct WalletCard: Codable, Hashable, Identifiable {
    var id: String {
        return card.id
    }
    let card: Card
    let count: Int
}

struct WalletPriceCard: Codable, Identifiable, Hashable {
    let walletCard: WalletCard
    let price: Double
    
    var id: String {
        return walletCard.id
    }
    
    enum CodingKeys: String, CodingKey {
        case walletCard = "first"
        case price = "second"
    }
}

final class WalletViewModel: ObservableObject {
    @Published var topCards: [WalletPriceCard]?
    @Published var pendingOrders: [MasterOrder]?
    
    @Published var selectedPendingOrder: MasterOrder?
    
    @MainActor func fetchTopCards(userId: Int) async {
        let url = URL(string: "https://andreascs.com/api/user/\(userId)/top3_cards")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.topCards = try JSONDecoder().decode([WalletPriceCard].self, from: data)
        } catch {
            self.topCards = []
            print(error.localizedDescription)
        }
    }
    
    @MainActor func fetchOutstandingOrders(userId: Int) async {
        let url = URL(string: "https://andreascs.com/api/snapshot?userId=\(userId)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            decoder.dateDecodingStrategy = Foundation.JSONDecoder.DateDecodingStrategy.formatted(formatter)
            self.pendingOrders = try decoder.decode([MasterOrder].self, from: data)
        } catch {
            self.pendingOrders = []
            print(error.localizedDescription)
        }
    }
}
