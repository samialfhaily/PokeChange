//
//  EditOrderSheet.swift
//  App
//
//  Created by Sami Alfhaily on 20.11.22.
//

import SwiftUI

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
