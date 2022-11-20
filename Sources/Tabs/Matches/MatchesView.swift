//
//  MatchesView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

final class MatchesViewModel: ObservableObject {
    @Published private(set) var matches: [Match]?
    
    @MainActor func fetchMatches(userId: Int? = nil, cardId: String? = nil) async {
        var components = URLComponents(string: "https://andreascs.com/api/matches")!
        var queryItems: [URLQueryItem] = []
        
        if let userId {
            queryItems.append(URLQueryItem(name: "userId", value: String(userId)))
        }
        
        if let cardId {
            queryItems.append(URLQueryItem(name: "cardId", value: cardId))
        }
        
        components.queryItems = queryItems
        
        let url = components.url!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            decoder.dateDecodingStrategy = Foundation.JSONDecoder.DateDecodingStrategy.formatted(formatter)
            self.matches = try decoder.decode([Match].self, from: data)
        } catch {
            self.matches = []
            print(error.localizedDescription)
        }
    }
}

struct MatchesView: View {
    @StateObject private var viewModel = MatchesViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if let matches = viewModel.matches {
                    List {
                        ForEach(matches) { match in
                            NavigationLink(value: match) {
                                MatchEntryRow(match: match)
                            }
                        }
                    }
                } else {
                    ProgressView("Loading...")
                        .task {
                            await viewModel.fetchMatches()
                        }
                }
            }
            .navigationDestination(for: Match.self) { match in
                MatchDetailsView(match: match)
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
