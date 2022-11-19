//
//  PendingOrderRow.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

struct PendingOrderRow: View {
    let order: MasterOrder
    
    var body: some View {
        HStack(alignment: .top, spacing: .zero) {
            AsyncImage(url: order.card.imageUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 104.7)
                    .padding(.trailing, 15)
            } placeholder: {
                Color.gray
                    .frame(width: 75, height: 104.7)
                    .cornerRadius(3)
                    .padding(.trailing, 15)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: .zero) {
                    Text("\(order.card.name) - \(order.quantity)x cards")
                        .font(.headline)
                        .bold()
                    
                    Spacer(minLength: .zero)
                }
                
                Text(order.placeDate, format: .dateTime)
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text(order.price * Double(order.quantity), format: .currency(code: "USD"))
                    .font(.headline)
                
                Spacer(minLength: .zero)
                
                HStack(spacing: .zero) {
                    Text(order.side.rawValue)
                        .foregroundColor(order.side == .buy ? .bbRed : .green)
                }
                .padding(.bottom, 4)
            }
            
            Spacer(minLength: .zero)
        }
        .frame(height: 104.7)
    }
}

struct PendingOrderRow_Previews: PreviewProvider {
    static var previews: some View {
        PendingOrderRow(
            order: MasterOrder(
                id: 0,
                card: Card(id: "abc", name: "Pikachu", rarity: .amazingRare, imageUrl: URL(string: "https://images.pokemontcg.io/xy1/1.png")!),
                quantity: 10,
                price: 100,
                side: .buy,
                username: "sami",
                completed: false,
                placeDate: .now
            )
        )
    }
}
