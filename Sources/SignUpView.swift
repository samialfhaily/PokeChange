//
//  SignUpView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
}

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    
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
                BBTextField("Email", text: $viewModel.email, imageName: "envelope.fill")
                BBTextField("Username", text: $viewModel.username, imageName: "person.fill")
                BBTextField("Password", text: $viewModel.password, imageName: "lock.fill", isSecure: true)
                BBTextField("Confirm Password", text: $viewModel.confirmPassword, imageName: "lock.fill", isSecure: true)
            }
            .padding(.bottom, 10)
            
            BBButton(.primary) {
                print("signed up")
            } label: {
                Text("Sign Up")
            }
            .padding(.bottom, -10)
            
            HStack {
                Text("Already have an account?")
                
                BBButton(.secondary) {
                    print("clicked login")
                } label: {
                    Text("Sign In")
                }
            }
        }
        .padding(20)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
