//
//  MarketplaceDetailsView.swift
//  App
//
//  Created by Atharva Mathapati on 19.11.22.
//

import SwiftUI

/*
struct Response: Codable {
    var orders: [Order]
}
 struct Order: Codable {
    let buy: [MasterOrder]
    let sell: [MasterOrder]
}
 */

struct MarketplaceDetailsView: View {
    let card: Card
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .bottom, spacing: 4) {
                AsyncImage(url: card.imageUrl, transaction: Transaction(animation: .default)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 209.4)
                            .padding(.trailing, 15)
                    default:
                        Color.gray
                            .frame(width: 150, height: 209.4)
                            .cornerRadius(8)
                            .padding(.trailing, 15)
                    }
                }
                
                VStack(alignment: .leading, spacing: .zero) {
                    Text(card.name)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(card.rarity?.rawValue ?? "Unknown")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .bold()
                        .padding(.bottom, 2)
                        .foregroundColor(.secondary)
                    Text("Owned: 5")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .bold()
                        .padding(.bottom, 2)
                        .foregroundColor(.secondary)
                }
                
                Spacer(minLength: .zero)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Buy Requests")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer(minLength: .zero)
                }
                
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Sell Offers")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer(minLength: .zero)
                }
                
            }
            
            Spacer(minLength: .zero)
            
            HStack (spacing: 20) {
                Button(action: {
                    ()
                }) {
                    Text("Sell")
                        .fontWeight(.bold)
                        .foregroundColor(.bbBlack)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(lineWidth: 2)
                                                .background(Color.green))
                        .cornerRadius(10)

                }
                
                Button(action: {
                    ()
                }) {
                    Text("Buy")
                        //.font(.system(size: CGFloat))
                        .fontWeight(.bold)
                        .foregroundColor(.bbBlack)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(lineWidth: 2)
                                                .background(Color.bbRed))
                        .cornerRadius(10)
                }
                
            }
            Spacer(minLength: .zero)
        }
         .padding(20)
         .navigationTitle(Text("Match Details"))
         .navigationBarTitleDisplayMode(.inline)
    }
}

struct MarketplaceDetailsView_Previews: PreviewProvider {
    static let card = Card(id: "abc", name: "Pikachu", rarity: .amazingRare, imageUrl: URL(string: "https://images.pokemontcg.io/xy1/1.png")!)
    static var previews: some View {
        MarketplaceDetailsView(card: card)
    }
}
