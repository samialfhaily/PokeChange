//
//  RootView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

struct RootView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            MarketplaceView()
                .tag(0)
                .tabItem {
                    Label("Marketplace", systemImage: "cart")
                }
            
            WalletView()
                .tag(1)
                .tabItem {
                    Label("Wallet", systemImage: "bag")
                }
            
            MatchesView()
                .tag(2)
                .tabItem {
                    Label("Matches", systemImage: "doc.plaintext.fill")
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
