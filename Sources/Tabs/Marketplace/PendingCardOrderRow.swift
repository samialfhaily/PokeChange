//
//  PendingCardOrderRow.swift
//  App
//
//  Created by Sami Alfhaily on 20.11.22.
//

import SwiftUI

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
