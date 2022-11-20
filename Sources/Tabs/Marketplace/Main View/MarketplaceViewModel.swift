//
//  MarketplaceViewModel.swift
//  App
//
//  Created by Sami Alfhaily on 20.11.22.
//

import Foundation
import Combine

final class MarketplaceViewModel: ObservableObject {
    @Published var cards: [Card]?
    @Published var searchQuery = ""
    
    private var cancellables: Set<AnyCancellable> = []
    private var runningTask: Task<Void, Never>?
    
    init() {
        $searchQuery.debounce(for: .seconds(0.3), scheduler: RunLoop.main).sink { query in
            self.runningTask?.cancel()
            
            self.runningTask = Task {
                await self.fetchCards(query: query)
            }
        }.store(in: &cancellables)
    }
    
    @MainActor private func fetchCards(query: String) async {
        let url = URL(string: "https://andreascs.com/api/cards?q=\(query.trimmingCharacters(in: .whitespacesAndNewlines))")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.cards = try JSONDecoder().decode([Card].self, from: data)
        } catch {
            self.cards = []
            print(error.localizedDescription)
        }
    }
}
