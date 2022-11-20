//
//  EditOrderSheetViewModel.swift
//  App
//
//  Created by Sami Alfhaily on 20.11.22.
//

import Foundation

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
