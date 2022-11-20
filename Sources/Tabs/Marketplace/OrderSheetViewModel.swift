//
//  BuySheet.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

struct PlaceOrderPayload: Encodable {
    let cardId: String
    let price: Double
    let quantity: Int
    let side: String
    let username: String
}

final class OrderSheetViewModel: ObservableObject {
    @Published var quantityString = ""
    @Published var priceString = ""
    
    @Published private(set) var isPlacingOrder = false
    
    @MainActor func placeOrder(username: String, cardId: String, side: Side) async -> Bool {
        guard let price = Double(priceString), let quantity = Int(quantityString) else { return false}
        isPlacingOrder = true
        
        let url = URL(string: "https://andreascs.com/api/order")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let encoder = JSONEncoder()
            let payload = PlaceOrderPayload(cardId: cardId, price: price, quantity: quantity, side: side.rawValue, username: username)
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

struct OrderSheetView: View {
    @StateObject private var viewModel = OrderSheetViewModel()
    let side: Side
    let cardId: String
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Quantity") {
                    TextField("15", text: $viewModel.quantityString)
                }
                
                Section("Price") {
                    HStack {
                        Text("$")
                        TextField("100", text: $viewModel.priceString)
                    }
                }
                
                Section("Side") {
                    Text(side.rawValue)
                        .foregroundColor(side == .buy ? .green : .bbRed)
                }
                
                Section {
                    Button {
                        Task {
                            if (await viewModel.placeOrder(username: authenticationManager.user.username, cardId: cardId, side: side)) {
                                dismiss()
                            }
                        }
                    } label: {
                        if viewModel.isPlacingOrder {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Place Order")
                                .frame(maxWidth: .infinity)
                                .bold()
                        }
                    }
                    .disabled(viewModel.quantityString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                              || viewModel.priceString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .navigationBarTitle(Text("New Order"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct OrderSheetView_Previews: PreviewProvider {
    static var previews: some View {
        OrderSheetView(side: .buy, cardId: "1")
    }
}
