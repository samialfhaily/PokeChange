//
//  WalletView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

final class WalletViewModel: ObservableObject {
    @Published var topCards: [Card]?
    @Published var pendingOrders: [MasterOrder]?
    
    func fetchTopCards() async {
        topCards = []
    }
    
    func fetchOutstandingOrders() async {
        pendingOrders = []
    }
}

struct WalletView: View {
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    @StateObject private var viewModel = WalletViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack(spacing: .zero) {
                        Text(authenticationManager.user.balance, format: .currency(code: "USD"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.bbBlue)
                        
                        Spacer(minLength: .zero)
                    }
                    
                    // TOP 3 Owned Cards
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Top Owned Cards")
                            .font(.title3)
                            .bold()
                        
                        if let topCards = viewModel.topCards {
                            ForEach(topCards) { card in
                                TopCardRow(card: card, count: 1)
                            }
                        } else {
                            ProgressView("Loading...")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .task {
                                    await viewModel.fetchTopCards()
                                }
                        }
                    }
                    .animation(.default, value: viewModel.topCards)
                    
                    // Pending orders
                    // TOP 3 Owned Cards
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Pending Orders")
                            .font(.title3)
                            .bold()
                        
                        if let pendingOrders = viewModel.pendingOrders {
                            ForEach(pendingOrders) { order in
                                PendingOrderRow(order: order)
                            }
                        } else {
                            ProgressView("Loading...")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .task {
                                    await viewModel.fetchOutstandingOrders()
                                }
                        }
                    }
                    .animation(.default, value: viewModel.pendingOrders)
                    
                    Spacer(minLength: .zero)
                }
                .padding(20)
            }
            .navigationTitle(Text("Wallet"))
        }
    }
}

struct WalletView_Previews: PreviewProvider {
    struct WalletViewPreview: View {
        @StateObject private var authenticationManager = AuthenticationManager()
        
        var body: some View {
            WalletView()
                .environmentObject(authenticationManager)
        }
    }
    
    static var previews: some View {
        WalletViewPreview()
    }
}
