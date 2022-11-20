//
//  WalletView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

struct WalletView: View {
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    @StateObject private var viewModel = WalletViewModel()
    
    var body: some View {
        let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
        
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
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .center, spacing: .zero) {
                            Text("Most Valuable Cards")
                                .font(.title3)
                                .bold()
                            
                            Spacer(minLength: .zero)
                            
                            if viewModel.topCards?.count ?? 0 >= 3 {
                                NavigationLink(destination: AllCardsListView()) {
                                    HStack(spacing: .zero) {
                                        Text("See All ")
                                        Image(systemName: "chevron.right")
                                    }
                                }
                            }
                        }
                        
                        if let topCards = viewModel.topCards {
                            Group {
                                if topCards.isEmpty {
                                    Text("No cards found.")
                                } else {
                                    ForEach(topCards) { card in
                                        TopCardRow(walletCard: card.walletCard)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ProgressView("Loading...")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .task {
                                    await viewModel.fetchTopCards(userId: authenticationManager.user.id)
                                }
                        }
                    }
                    .animation(.default, value: viewModel.topCards)
                    
                    // Pending orders
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pending Orders")
                            .font(.title3)
                            .bold()
                        
                        if let pendingOrders = viewModel.pendingOrders {
                            Group {
                                if pendingOrders.isEmpty {
                                    Text("You don't have any pending orders.")
                                } else {
                                    ForEach(pendingOrders) { order in
                                        PendingOrderRow(order: order)
                                            .onTapGesture {
                                                viewModel.selectedPendingOrder = order
                                            }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ProgressView("Loading...")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .task {
                                    await viewModel.fetchOutstandingOrders(userId: authenticationManager.user.id)
                                }
                        }
                    }
                    .animation(.default, value: viewModel.pendingOrders)
                    
                    Spacer(minLength: .zero)
                }
                .padding(20)
                .onAppear {
                    viewModel.topCards = nil
                    viewModel.pendingOrders = nil
                    Task {
                        await authenticationManager.signIn(username: authenticationManager.user.username, password: authenticationManager.user.password)
                    }
                }
                .sheet(item: $viewModel.selectedPendingOrder) {
                    viewModel.topCards = nil
                    viewModel.pendingOrders = nil
                    Task {
                        await authenticationManager.signIn(username: authenticationManager.user.username, password: authenticationManager.user.password)
                    }
                } content: { order in
                    EditOrderSheet(order: order)
                }
            }
            .navigationTitle(Text("Wallet"))
            .onReceive(timer) { _ in
                Task {
                    await viewModel.fetchTopCards(userId: authenticationManager.user.id)
                    await viewModel.fetchOutstandingOrders(userId: authenticationManager.user.id)
                }
            }
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
