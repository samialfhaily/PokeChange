//
//  AllCardsListView.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

final class AllCardsListViewModel: ObservableObject {
    @Published var walletCards: [WalletCard]?
    
    @MainActor func fetchCards(userId: Int) async {
        let url = URL(string: "https://andreascs.com/\(userId)/cards")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.walletCards = try JSONDecoder().decode([WalletCard].self, from: data)
        } catch {
            self.walletCards = []
            print(error.localizedDescription)
        }
    }
}

struct AllCardsListView: View {
    @StateObject private var viewModel = AllCardsListViewModel()
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    
    private var columns: [GridItem] {
        return [
            GridItem(.flexible(), spacing: 16, alignment: .center),
            GridItem(.flexible(), spacing: 16, alignment: .center)
        ]
    }
    
    var body: some View {
        Group {
            if let walletCards = viewModel.walletCards {
                LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
                    ForEach(walletCards) { walletCard in
                        thumbnail(walletCard: walletCard)
                            .clipped()
                    }
                }
            } else {
                ProgressView("Loading...")
                    .task {
                        await viewModel.fetchCards(userId: authenticationManager.user.id)
                    }
            }
        }
        .animation(.default, value: viewModel.walletCards)
    }
    
    private func thumbnail(walletCard: WalletCard) -> some View {
        VStack(spacing: 4) {
            ZStack {
                AsyncImage(url: walletCard.card.imageUrl, transaction: Transaction(animation: .default)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    default:
                        Color.gray
                            .frame(width: (UIScreen.main.bounds.width - 48) / 2, height: (UIScreen.main.bounds.width - 48) / 2 * 1.395)
                            .cornerRadius(8)
                            .clipped()
                    }
                }
                
                VStack(spacing: .zero) {
                    HStack(spacing: .zero) {
                        Text("PRICE")
                        Spacer(minLength: .zero)
                    }
                    
                    HStack(spacing: .zero) {
                        Spacer(minLength: .zero)
                        Text(walletCard.count, format: .number)
                    }
                }
            }
            
            Text(walletCard.card.name)
                .font(.caption)
                .lineLimit(1)
        }
    }
}

struct AllCardsListView_Previews: PreviewProvider {
    @StateObject static private var authenticationManager = AuthenticationManager()
    static var previews: some View {
        AllCardsListView()
            .environmentObject(authenticationManager)
    }
}
