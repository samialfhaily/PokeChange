//
//  MatchEntryRow.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

struct MatchEntryRow: View {
    let match: Match
    
    var body: some View {
        HStack(spacing: 0) {
            AsyncImage(url: match.buyingOrder.masterOrder.card.imageUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 55.87)
                    .padding(.trailing, 15)
            } placeholder: {
                Color.gray
                    .frame(width: 40, height: 55.87)
                    .cornerRadius(3)
                    .padding(.trailing, 15)
            }
            
            VStack(spacing: 6) {
                HStack(spacing: .zero) {
                    Text("\(match.buyingOrder.masterOrder.card.name) - \(match.buyingOrder.quantity)x")
                        .font(.headline)
                        .bold()
                    
                    Spacer(minLength: .zero)
                    
                    Text(match.sellingOrder.price * Double(match.sellingOrder.quantity), format: .currency(code: "USD"))
                        .font(.headline)
                }
                
                HStack(spacing: .zero) {
                    HStack {
                        Text(match.sellingOrder.masterOrder.username)
                            .foregroundColor(.bbRed)
                        Image(systemName: "arrow.right")
                        Text(match.buyingOrder.masterOrder.username)
                            .foregroundColor(.green)
                    }
                    .font(.footnote)
                    
                    Spacer(minLength: .zero)
                    
                    Text(match.sellingOrder.executionDate, style: .time)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer(minLength: .zero)
        }
    }
}

struct MatchEntryRow_Previews: PreviewProvider {
    static var previews: some View {
        MatchEntryRow(
            match: Match(
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
        )
    }
}
