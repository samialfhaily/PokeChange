//
//  WalletView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

struct WalletCard: Codable, Hashable, Identifiable {
    var id: String {
        return card.id
    }
    let card: Card
    let count: Int
}

final class WalletViewModel: ObservableObject {
    @Published var topCards: [WalletCard]?
    @Published var pendingOrders: [MasterOrder]?
    
    @MainActor func fetchTopCards(userId: Int) async {
        let url = URL(string: "https://andreascs.com/api/\(userId)/top_cards")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.topCards = try JSONDecoder().decode([WalletCard].self, from: data)
        } catch {
            self.topCards = []
            print(error.localizedDescription)
        }
    }
    
    @MainActor func fetchOutstandingOrders(userId: Int) async {
        let url = URL(string: "https://andreascs.com/api/orders/\(userId)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.pendingOrders = try JSONDecoder().decode([MasterOrder].self, from: data)
        } catch {
            self.pendingOrders = []
            print(error.localizedDescription)
        }
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
                        HStack(alignment: .center, spacing: .zero) {
                            Text("Top Owned Cards")
                                .font(.title3)
                                .bold()
                            
                            Spacer(minLength: .zero)
                            
                            if viewModel.topCards?.count ?? 0 > 3 {
                                BBButton(.secondary) {
                                    print("CLICKED")
                                } label: {
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
                                        TopCardRow(walletCard: card)
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
                    VStack(alignment: .leading, spacing: 8) {
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
                }
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
