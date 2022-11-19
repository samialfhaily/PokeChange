//
//  MatchEntryRow.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

struct MatchEntryRow: View {
//    let match: Match
    
    var body: some View {
        HStack(spacing: 0) {
            AsyncImage(url: URL(string: "https://images.pokemontcg.io/xy1/1.png")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 55.87)
                    .padding(.trailing, 15)
            } placeholder: {
                Color.gray
                    .frame(width: 40, height: 55.87)
                    .padding(.trailing, 15)
            }
            
            VStack(spacing: 6) {
                HStack(spacing: .zero) {
                    Text("Fletchinder - 5x")
                        .font(.headline)
                        .bold()
                    
                    Spacer(minLength: .zero)
                    
                    Text("$99.99")
                        .font(.headline)
                }
                
                HStack(spacing: .zero) {
                    HStack {
                        Text("Sami")
                            .foregroundColor(.bbRed)
                        Image(systemName: "arrow.right")
                        Text("Atharva")
                            .foregroundColor(.green)
                    }
                    .font(.footnote)
                    
                    Spacer(minLength: .zero)
                    
                    Text("Nov 19, 2:00 pm")
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
        MatchEntryRow()
    }
}
