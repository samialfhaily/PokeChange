//
//  MasterOrder.swift
//  App
//
//  Created by Atharva Mathapati on 19.11.22.
//

import Foundation

struct MasterOrder: Codable, Hashable, Identifiable {
    let id: Int
    let card: Card
    let quantity: Int
    let price: Double
    let side: Side
    let username: String
    let completed: Bool
    let placeDate: Date
}
