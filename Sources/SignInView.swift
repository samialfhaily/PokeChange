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
}

struct SignInView: View {
    @StateObject private var viewModel = SignUpViewModel()

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
                print("signed in")
            } label: {
                Text("Sign In")
            }
            .padding(.bottom, -10)
            
            HStack {
                Text("Don't have an account?")
                
                BBButton(.secondary) {
                    print("clicked signup")
                } label: {
                    Text("Sign Up")
                }
            }
        }
        .padding(20)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
