//
//  SignInView.swift
//  App
//
//  Created by Atharva Mathapati on 19.11.22.
//

import SwiftUI

class SignInViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    
    @Published var isPresentingSignUpSheet = false
    
    var isSignInButtonDisabled: Bool {
        return username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Xchange")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Sign Into Your Account")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
            
            VStack(spacing: 20) {
                BBTextField("Username", text: $viewModel.username, imageName: "person.fill")
                BBTextField("Password", text: $viewModel.password, imageName: "lock.fill", isSecure: true)
            }
            .padding(.bottom, 10)
            
            BBButton(.primary) {
                Task {
                    await authenticationManager.signIn(username: viewModel.username, password: viewModel.password)
                }
            } label: {
                Text("Sign In")
            }
            .disabled(viewModel.isSignInButtonDisabled)
            .padding(.bottom, -10)
            
            HStack {
                Text("Don't have an account?")
                
                BBButton(.secondary) {
                    viewModel.isPresentingSignUpSheet = true
                } label: {
                    Text("Sign Up")
                }
            }
        }
        .padding(20)
        .sheet(isPresented: $viewModel.isPresentingSignUpSheet) {
            SignUpView()
                .environmentObject(authenticationManager)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
