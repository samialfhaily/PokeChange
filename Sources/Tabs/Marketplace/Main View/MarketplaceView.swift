//
//  MarketplaceView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

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
