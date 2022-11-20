//
//  User.swift
//  App
//
//  Created by Sami Alfhaily on 20.11.22.
//

import Foundation

struct User: Codable {
    let id: Int
    let username: String
    let password: String
    var balance: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case username = "name"
        case password
        case balance
    }
}
