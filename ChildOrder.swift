//
//  ChildOrder.swift
//  App
//
//  Created by Atharva Mathapati on 19.11.22.
//

import Foundation

struct ChildOrder: Hashable {
    let id: Int
    let masterOrder: MasterOrder
    let quantity: Int
    let price: Double
    let executionDate: Date
}