//
//  AuthenticationManager.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import Foundation

struct AuthenticationResponse: Codable {
    let user: User
}

struct AuthenticationPayload: Codable {
    let username: String
    let password: String
}

final class AuthenticationManager: ObservableObject {
    @Published var isSignedIn = false
    var user: User!
    
    @MainActor func signUp(username: String, password: String) async -> Bool {
        let url = URL(string: "https://andreascs.com/api/user/sign-up")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(AuthenticationPayload(username: username, password: password))
            let (data, _) = try await URLSession.shared.data(for: request)
            self.user = try JSONDecoder().decode(User.self, from: data)
            isSignedIn = true
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return true
    }
    
    @MainActor func signIn(username: String, password: String) async -> Bool {
        let url = URL(string: "https://andreascs.com/api/user/sign-in")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONEncoder().encode(AuthenticationPayload(username: username, password: password))
            let (data, _) = try await URLSession.shared.data(for: request)
            self.user = try JSONDecoder().decode(User.self, from: data)
            isSignedIn = true
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return true
    }
}
