//
//  MatchesView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

final class MatchesViewModel: ObservableObject {
    //    @Published private(set) var matches: [Match] = []
}

struct MatchesView: View {
    @StateObject private var viewModel = MatchesViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: OrderDetailsView(viewModel: OrderDetailsViewModel(orderId: 10))) {
                    MatchEntryRow()
                }
            }
            .navigationTitle(Text("Matches"))
        }
    }
}

struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
    }
}
