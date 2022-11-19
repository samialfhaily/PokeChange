//
//  Card.swift
//  App
//
//  Created by Atharva Mathapati on 19.11.22.
//

import Foundation

struct Card: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let rarity: CardRarity?
    let imageUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case id = "cardId"
        case name
        case rarity
        case imageUrl
    }
}
