//
//  BuySheet.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

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
