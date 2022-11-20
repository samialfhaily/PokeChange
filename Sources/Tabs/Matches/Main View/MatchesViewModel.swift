//
//  MatchesViewModel.swift
//  App
//
//  Created by Sami Alfhaily on 20.11.22.
//

import Foundation

final class MatchesViewModel: ObservableObject {
    @Published private(set) var matches: [Match]?
    @Published var userId = ""
    @Published var cardId = ""
    @Published var side: Side.RawValue = "All"
    
    @MainActor func fetchMatches() async {
        var components = URLComponents(string: "https://andreascs.com/api/matches")!
        var queryItems: [URLQueryItem] = []
        
        if !userId.isEmpty {
            queryItems.append(URLQueryItem(name: "userId", value: String(userId)))
        }
        
        if !cardId.isEmpty {
            queryItems.append(URLQueryItem(name: "cardId", value: cardId))
        }
        
        if side != "All" {
            queryItems.append(URLQueryItem(name: "side", value: side))
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
