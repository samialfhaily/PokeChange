//
//  SignInViewModel.swift
//  App
//
//  Created by Sami Alfhaily on 20.11.22.
//

import Foundation

final class SignInViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    
    @Published var isPresentingSignUpSheet = false
    
    var isSignInButtonDisabled: Bool {
        return username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
