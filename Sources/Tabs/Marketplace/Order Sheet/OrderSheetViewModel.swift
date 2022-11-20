//
//  OrderSheetViewModel.swift
//  App
//
//  Created by Sami Alfhaily on 20.11.22.
//

import Foundation

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
            print(response)
        } catch {
            print(error.localizedDescription)
        }
        
        isPlacingOrder = false
        return false
    }
}
