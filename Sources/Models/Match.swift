//
//  Match.swift
//  App
//
//  Created by Atharva Mathapati on 19.11.22.
//

import Foundation

struct Match: Identifiable, Hashable, Codable {
    let id: Int
    let buyingOrder: MasterOrder
    let sellingOrder: MasterOrder
    let quantity: Int
    let price: Double
    let executionDate: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case buyingOrder = "buyer"
        case sellingOrder = "seller"
        case quantity
        case price
        case executionDate = "created"
    }
}
