//
//  MatchesView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

final class MatchesViewModel: ObservableObject {
    @Published private(set) var matches: [Match] = []
}

struct MatchesView: View {
    @StateObject private var viewModel = MatchesViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.matches) { match in
                    NavigationLink(value: match) {
                        MatchEntryRow(match: match)
                    }
                }
                .navigationDestination(for: Match.self) { match in
                    MatchDetailsView(match: match)
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
