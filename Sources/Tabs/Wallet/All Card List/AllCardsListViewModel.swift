//
//  AllCardsListViewModel.swift
//  App
//
//  Created by Sami Alfhaily on 20.11.22.
//

import Foundation

final class AllCardsListViewModel: ObservableObject {
    @Published var walletCards: [WalletCard]?
    
    @MainActor func fetchCards(userId: Int) async {
        let url = URL(string: "https://andreascs.com/api/user/\(userId)/cards?sortBy=NAME")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.walletCards = try JSONDecoder().decode([WalletCard].self, from: data)
        } catch {
            self.walletCards = []
            print(error.localizedDescription)
        }
    }
}
