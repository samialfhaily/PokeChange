//
//  BBTextField.swift
//  App
//
//  Created by Sami Alfhaily on 19.11.22.
//

import SwiftUI

struct BBTextField: View {
    private let titleKey: LocalizedStringKey
    private let imageName: String
    private let isSecure: Bool
    @Binding private var text: String
    
    @State private var isShowingInput = false
    
    init(_ titleKey: LocalizedStringKey, text: Binding<String>, imageName: String, isSecure: Bool = false) {
        self.titleKey = titleKey
        self._text = text
        self.imageName = imageName
        self.isSecure = isSecure
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: imageName)
                .frame(width: 20)
            
            Group {
                if isSecure {
                    ZStack(alignment: .trailing) {
                        if isShowingInput {
                            TextField(titleKey, text: $text)
                        } else {
                            SecureField(titleKey, text: $text)
                        }
                        
                        Image(systemName: isShowingInput ? "eye.fill" : "eye.slash.fill")
                            .onTapGesture {
                                isShowingInput.toggle()
                            }
                    }
                } else {
                    TextField(titleKey, text: $text)
                }
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 20)
        .frame(height: 50)
        .background(Color.bbGray)
        .cornerRadius(5)
        .shadow(color: .black, radius: 0, x: 0, y: 1)
    }
}

struct BBTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BBTextField("Password", text: .constant("SECURE PASSWORD"), imageName: "lock.fill", isSecure: true)
            BBTextField("Email", text: .constant("EMAIL"), imageName: "envelope.fill")
        }
    }
}
