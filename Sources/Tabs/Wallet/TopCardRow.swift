//
//  TopCardRow.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

struct TopCardRow: View {
    let card: Card
    let count: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: .zero) {
            AsyncImage(url: card.imageUrl, transaction: Transaction(animation: .default)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 104.7)
                        .padding(.trailing, 15)
                default:
                    Color.gray
                        .frame(width: 75, height: 104.7)
                        .cornerRadius(3)
                        .padding(.trailing, 15)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(card.name)
                    .font(.title2)
                    .bold()
                
                Text(card.rarity?.rawValue ?? "Unknown")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Spacer(minLength: .zero)
                
                HStack(spacing: .zero) {
                    Text("Owned: ")
                    Text(count, format: .number)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 4)
            }
            
            Spacer(minLength: .zero)
        }
        .frame(height: 104.7)
    }
}

struct TopCardRow_Previews: PreviewProvider {
    static var previews: some View {
        TopCardRow(card: Card(id: "abc", name: "Pikachu", rarity: .amazingRare, imageUrl: URL(string: "https://images.pokemontcg.io/xy1/1.png")!), count: 2)
    }
}
