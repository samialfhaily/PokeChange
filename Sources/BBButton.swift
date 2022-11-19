//
//  BBButton.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

struct BBButton<T: View>: View {
    private let style: Self.Style
    private let action: () -> Void
    @ViewBuilder private let label: () -> T
    
    init(_ style: Self.Style, action: @escaping () -> Void, label: @escaping () -> T) {
        self.style = style
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button(action: action) {
            switch style {
            case .primary:
                label()
                    .foregroundColor(.white)
                    .bold()
                    .frame(height: 59)
                    .frame(maxWidth: .infinity)
                    .background(Color.bbBlue)
                    .cornerRadius(5)
            case .secondary:
                label()
                    .foregroundColor(.bbBlue)
            }
        }
    }
}

extension BBButton {
    enum Style {
        case primary
        case secondary
    }
}

struct BBButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BBButton(.primary, action: {}, label: { Text("Primary Button") })
            BBButton(.secondary, action: {}, label: { Text("Secondary Button") })
        }
    }
}
