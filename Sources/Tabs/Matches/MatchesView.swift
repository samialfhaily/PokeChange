//
//  MatchesView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

final class MatchesViewModel: ObservableObject {
    @Published private(set) var matches: [Match] = [
        Match(
            id: 0,
            buyingOrder: ChildOrder(
                id: 1,
                masterOrder: MasterOrder(
                    id: 1,
                    card: Card(id: "abc", name: "Pikachu", rarity: .amazingRare, imageUrl: URL(string: "https://images.pokemontcg.io/xy1/1.png")!),
                    quantity: 1,
                    price: 10,
                    side: .buy,
                    username: "sami",
                    completed: true,
                    placeDate: .now
                ),
                quantity: 5,
                price: 10,
                executionDate: .now
            ),
            sellingOrder: ChildOrder(
                id: 1,
                masterOrder: MasterOrder(
                    id: 2,
                    card: Card(id: "abc", name: "Pikachu", rarity: .amazingRare, imageUrl: URL(string: "https://images.pokemontcg.io/xy1/1.png")!),
                    quantity: 1,
                    price: 10,
                    side: .sell,
                    username: "atharva",
                    completed: true,
                    placeDate: .now
                ),
                quantity: 5,
                price: 10,
                executionDate: .now
            )
        )
    ]
}

struct MatchesView: View {
    @StateObject private var viewModel = MatchesViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.matches) { match in
                    NavigationLink(value: match) {
                        MatchEntryRow(match: match)
                    }
                }
                .navigationDestination(for: Match.self) { match in
                    MatchDetailsView(match: match)
                }
            }
            .navigationTitle(Text("Matches"))
        }
    }
}

struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
    }
}
