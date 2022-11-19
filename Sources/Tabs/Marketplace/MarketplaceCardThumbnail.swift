//
//  MarketplaceCardThumbnail.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

struct MarketplaceCardThumbnail: View {
    let card: Card
    
    var body: some View {
        VStack(spacing: 4) {
            AsyncImage(url: card.imageUrl, transaction: Transaction(animation: .default)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                default:
                    Color.gray
                        .frame(width: (UIScreen.main.bounds.width - 48) / 2, height: (UIScreen.main.bounds.width - 48) / 2 * 1.395)
                        .cornerRadius(8)
                        .clipped()
                }
            }
            
            Text(card.name)
                .font(.caption)
                .lineLimit(1)
        }
    }
}

struct MarketplaceCardThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        MarketplaceCardThumbnail(card: Card(id: "abc-1", name: "Pikachu", rarity: .amazingRare, imageUrl: URL(string: "https://images.pokemontcg.io/xy1/1.png")!))
    }
}
