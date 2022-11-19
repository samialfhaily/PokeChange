//
//  Match.swift
//  App
//
//  Created by Atharva Mathapati on 19.11.22.
//

import Foundation

struct Match: Identifiable, Hashable {
    let id: Int
    let buyingOrder: MasterOrder
    let sellingOrder: MasterOrder
    let quantity: Int
    let price: Double
    let executionDate: Date
}
