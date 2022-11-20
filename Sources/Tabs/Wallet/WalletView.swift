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

struct WalletPriceCard: Codable, Identifiable, Hashable {
    let walletCard: WalletCard
    let price: Double
    
    var id: String {
        return walletCard.id
    }
    
    enum CodingKeys: String, CodingKey {
        case walletCard = "first"
        case price = "second"
    }
}

final class WalletViewModel: ObservableObject {
    @Published var topCards: [WalletPriceCard]?
    @Published var pendingOrders: [MasterOrder]?
    
    @Published var selectedPendingOrder: MasterOrder?
    
    @MainActor func fetchTopCards(userId: Int) async {
        let url = URL(string: "https://andreascs.com/api/user/\(userId)/top3_cards")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.topCards = try JSONDecoder().decode([WalletPriceCard].self, from: data)
        } catch {
            self.topCards = []
            print(error.localizedDescription)
        }
    }
    
    @MainActor func fetchOutstandingOrders(userId: Int) async {
        let url = URL(string: "https://andreascs.com/api/snapshot?userId=\(userId)")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            decoder.dateDecodingStrategy = Foundation.JSONDecoder.DateDecodingStrategy.formatted(formatter)
            self.pendingOrders = try decoder.decode([MasterOrder].self, from: data)
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
        }
    }
}

final class EditOrderSheetViewModel: ObservableObject {
    @Published var quantityString = ""
    
    @Published private(set) var isPlacingOrder = false
    
    @MainActor func editOrder(order: MasterOrder) async -> Bool {
        guard let quantity = Int(quantityString) else { return false}
        isPlacingOrder = true
        
        let url = URL(string: "https://andreascs.com/api/order")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        
        do {
            let encoder = JSONEncoder()
            let payload = PlaceOrderPayload(cardId: order.card.id, price: order.price, quantity: order.quantity - quantity, side: order.side.rawValue, username: order.username)
            request.httpBody = try encoder.encode(payload)
            let (_, response) = try await URLSession.shared.data(for: request)
            if (response as? HTTPURLResponse)?.statusCode == 201 || (response as? HTTPURLResponse)?.statusCode == 200 {
                return true
            }
        } catch {
            print(error.localizedDescription)
        }
        
        isPlacingOrder = false
        return false
    }
}

struct EditOrderSheet: View {
    @StateObject private var viewModel = EditOrderSheetViewModel()
    let order: MasterOrder
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Quantity") {
                    TextField("15", text: $viewModel.quantityString)
                }
                
                Section("Price") {
                    HStack {
                        Text(order.price, format: .currency(code: "USD"))
                    }
                }
                
                Section("Side") {
                    Text(order.side.rawValue)
                        .foregroundColor(order.side == .buy ? .green : .bbRed)
                }
                
                Section {
                    Button {
                        Task {
                            if (await viewModel.editOrder(order: order)) {
                                dismiss()
                            }
                        }
                    } label: {
                        if viewModel.isPlacingOrder {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Edit Order")
                                .frame(maxWidth: .infinity)
                                .bold()
                        }
                    }
                    .disabled(viewModel.quantityString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .navigationBarTitle(Text("Edit Order"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.quantityString = String(order.quantity)
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
