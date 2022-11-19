//
//  ContentView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authenticationManager = AuthenticationManager()
    
    var body: some View {
        let isPresentingSignInSheet = Binding(
            get: { !authenticationManager.isSignedIn },
            set: { authenticationManager.isSignedIn = !$0 }
        )
        
        RootView()
            .fullScreenCover(isPresented: isPresentingSignInSheet) {
                SignInView()
                    .environmentObject(authenticationManager)
            }
            .environmentObject(authenticationManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
