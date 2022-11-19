//
//  OrderDetailsView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

final class OrderDetailsViewModel: ObservableObject {
    let orderId: Int
//    @Published private(set) var order: Order?
    
    init(orderId: Int) {
        self.orderId = orderId
    }
    
    @MainActor func fetchOrder() async {
        
    }
}

struct OrderDetailsView: View {
    @StateObject var viewModel: OrderDetailsViewModel
    
    var body: some View {
//        if let order = viewModel.order {
//            Text("\(viewModel.orderId)")
//        } else {
            ProgressView()
                .task {
                    await viewModel.fetchOrder()
                }
//        }
    }
}

struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView(viewModel: OrderDetailsViewModel(orderId: 10))
    }
}
