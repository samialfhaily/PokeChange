//
//  SignUpViewModel.swift
//  App
//
//  Created by Sami Alfhaily on 20.11.22.
//

import Foundation

final class SignUpViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    var isSignUpButtonDisabled: Bool {
        return username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || password != confirmPassword
    }
}
