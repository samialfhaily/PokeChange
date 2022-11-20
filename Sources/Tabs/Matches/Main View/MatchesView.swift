//
//  MatchesView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

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
                    await viewModel.fetchMatches()
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
