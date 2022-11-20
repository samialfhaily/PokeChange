//
//  Side.swift
//  App
//
//  Created by Atharva Mathapati on 19.11.22.
//

import Foundation

enum Side: String, Codable, Hashable, Identifiable {
    case buy = "BUY"
    case sell = "SELL"
    
    var id: Self {
        return self
    }
}
