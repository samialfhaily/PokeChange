//
//  MatchesView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

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

struct MatchesView: View {
    @StateObject private var viewModel = MatchesViewModel()
    
    var body: some View {
        let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
        
        NavigationStack {
            Form {
                Section("Filters") {
                    TextField("User ID", text: $viewModel.userId)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    TextField("Card ID", text: $viewModel.cardId)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    Picker("Side", selection: $viewModel.side) {
                        Text(Side.buy.rawValue).tag(Side.buy.rawValue)
                        Text(Side.sell.rawValue).tag(Side.sell.rawValue)
                        Text("All").tag("All")
                    }
                    .pickerStyle(.segmented)
                }
                Section {
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
                }
            }
            .navigationDestination(for: Match.self) { match in
                MatchDetailsView(match: match)
            }
            .navigationTitle(Text("Matches"))
            .onChange(of: viewModel.userId) { _ in
                Task {
                    await viewModel.fetchMatches()
                }
            }
            .onChange(of: viewModel.cardId) { _ in
                Task {
                    await viewModel.fetchMatches()
                }
            }
            .onChange(of: viewModel.side) { _ in
                Task {
                    await viewModel.fetchMatches()
                }
            }
            .onReceive(timer) { _ in
                Task {
                    await viewModel.fetchMatches
                }
            }
        }
    }
}

struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
    }
}
