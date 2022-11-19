//
//  MarketplaceView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI
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

struct MarketplaceView: View {
    @StateObject private var viewModel = MarketplaceViewModel()
    
    private var columns: [GridItem] {
        return [
            GridItem(.flexible(), spacing: 16, alignment: .center),
            GridItem(.flexible(), spacing: 16, alignment: .center)
        ]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    if let cards = viewModel.cards {
                        LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
                            ForEach(cards) { card in
                                NavigationLink(value: card) {
                                    MarketplaceCardThumbnail(card: card)
                                        .clipped()
                                }
                            }
                        }
                    } else {
                        ProgressView("Loading...")
                    }
                }
                .padding(16)
            }
            .searchable(text: $viewModel.searchQuery)
            .navigationTitle(Text("Marketplace"))
            .navigationDestination(for: Card.self) { card in
                MarketplaceCardDetailsView(card: card)
            }
        }
    }
}

struct MarketplaceView_Previews: PreviewProvider {
    static var previews: some View {
        MarketplaceView()
    }
}
