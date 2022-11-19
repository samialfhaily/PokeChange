//
//  Card.swift
//  App
//
//  Created by Atharva Mathapati on 19.11.22.
//

import Foundation

struct Card: Hashable, Identifiable {
    let id: String
    let name: String
    let rarity: CardRarity?
    let imageUrl: URL
}
