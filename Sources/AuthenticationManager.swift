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
    var balance: Double
}

final class AuthenticationManager: ObservableObject {
    @Published var isSignedIn = false
//    var user: User!
    
    var user: User {
        return User(id: 10, username: "sami", password: "12345678", balance: 3000)
    }
    
    @MainActor func signUp(username: String, password: String) async -> Bool {
        isSignedIn = true
        return true
    }
    
    @MainActor func signIn(username: String, password: String) async -> Bool {
        isSignedIn = true
        return true
    }
}
