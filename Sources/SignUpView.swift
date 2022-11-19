//
//  SignUpView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

class SignUpViewModel: ObservableObject {
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

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Xchange")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Create Your Account")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
            
            VStack(spacing: 20) {
                BBTextField("Username", text: $viewModel.username, imageName: "person.fill")
                BBTextField("Password", text: $viewModel.password, imageName: "lock.fill", isSecure: true)
                BBTextField("Confirm Password", text: $viewModel.confirmPassword, imageName: "lock.fill", isSecure: true)
            }
            .padding(.bottom, 10)
            
            BBButton(.primary) {
                Task {
                    if (await authenticationManager.signUp(username: viewModel.username, password: viewModel.password)) {
                        dismiss()
                    }
                }
            } label: {
                Text("Sign Up")
            }
            .disabled(viewModel.isSignUpButtonDisabled)
        }
        .padding(20)
    }
}

struct SignUpView_Previews: PreviewProvider {
    @StateObject static private var authenticationManager = AuthenticationManager()
    
    static var previews: some View {
        SignUpView()
            .environmentObject(authenticationManager)
    }
}
