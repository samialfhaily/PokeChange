//
//  MatchDetailsView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

struct MatchDetailsView: View {
    let match: Match
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .bottom, spacing: 4) {
                AsyncImage(url: match.buyingOrder.masterOrder.card.imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 209.4)
                        .padding(.trailing, 15)
                } placeholder: {
                    Color.gray
                        .frame(width: 150, height: 209.4)
                        .cornerRadius(8)
                        .padding(.trailing, 15)
                }
                
                VStack(alignment: .leading, spacing: .zero) {
                    Text(match.buyingOrder.masterOrder.card.name)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(match.buyingOrder.masterOrder.card.rarity?.rawValue ?? "Unknown")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .bold()
                        .padding(.bottom, 2)
                    
                    Text(match.buyingOrder.executionDate, format: .dateTime)
                        .foregroundColor(.secondary)
                }
                
                Spacer(minLength: .zero)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Buy Order")
                        .foregroundColor(.bbBlue)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer(minLength: .zero)
                    
                    Text(match.buyingOrder.masterOrder.username)
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                
                HStack(alignment: .bottom) {
                    Text("\(match.buyingOrder.masterOrder.quantity)x \(match.buyingOrder.masterOrder.quantity > 1 ? "Cards" : "Card")")
                    
                    Spacer(minLength: .zero)
                    
                    HStack(alignment: .center, spacing: .zero) {
                        Text(match.buyingOrder.masterOrder.price, format: .currency(code: "USD"))
                        Text(" per card")
                    }
                    .fontWeight(.semibold)
                }
                
                HStack(alignment: .bottom) {
                    if match.buyingOrder.masterOrder.completed {
                        Text("Fulfilled")
                            .foregroundColor(.green)
                            .bold()
                            .italic()
                    }
                    
                    Spacer(minLength: .zero)
                    
                    Text(match.buyingOrder.masterOrder.placeDate, format: .dateTime)
                }
            }
            .padding(8)
            .background(Color.bbGray)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Sell Order")
                        .foregroundColor(.bbBlue)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer(minLength: .zero)
                    
                    Text(match.sellingOrder.masterOrder.username)
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("\(match.sellingOrder.masterOrder.quantity)x \(match.sellingOrder.masterOrder.quantity > 1 ? "Cards" : "Card")")
                    
                    Spacer(minLength: .zero)
                    
                    HStack(alignment: .bottom, spacing: .zero) {
                        Text(match.sellingOrder.masterOrder.price, format: .currency(code: "USD"))
                        Text(" per card")
                    }
                    .fontWeight(.semibold)
                }
                
                HStack(alignment: .bottom) {
                    if match.sellingOrder.masterOrder.completed {
                        Text("Fulfilled")
                            .foregroundColor(.green)
                            .bold()
                            .italic()
                    }
                    
                    Spacer(minLength: .zero)
                    
                    Text(match.sellingOrder.masterOrder.placeDate, format: .dateTime)
                }
            }
            .padding(8)
            .background(Color.bbGray)
            .cornerRadius(8)
            
            HStack(spacing: .zero) {
                Text("Total Paid: ")
                    .bold()
                    .italic()
                Text(match.sellingOrder.price * Double(match.sellingOrder.quantity), format: .currency(code: "USD"))
                    .bold()
                    .foregroundColor(.bbRed)
            }
            
            Spacer(minLength: .zero)
        }
        .padding(20)
        .navigationTitle(Text("Match Details"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MatchDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MatchDetailsView(
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
