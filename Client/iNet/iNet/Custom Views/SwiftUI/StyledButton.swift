//
//  StyledButton.swift
//  iNet
//
//  Created by Saba Gogrichiani on 16.01.24.
//

import SwiftUI

struct StyledButton: View {
    var buttonText: String
    var buttonColor: Color
    var textColor: Color
    var icon: String?
    var buttonAction: () -> Void
    
    var body: some View {
        Button(action: buttonAction, label: {
            Group {
                if let icon = icon {
                    Label(LocalizedStringKey(buttonText), systemImage: icon)
                } else {
                    Text(LocalizedStringKey(buttonText))
                }
            }
            .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .semibold).font(size: 20))
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(buttonColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        })
    }
}
