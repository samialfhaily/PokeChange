//
//  AuthenticationManager.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import Foundation

struct User {
    let id: Int
    let username: String
    let password: String
}

final class AuthenticationManager: ObservableObject {
    @Published var isSignedIn = false
    var user: User!
}
