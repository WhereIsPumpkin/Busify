//
//  StyledTextField.swift
//  iNet
//
//  Created by Saba Gogrichiani on 16.01.24.
//

import SwiftUI

struct StyledTextField: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool

    var body: some View {
        Group {
            if isSecure {
                SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(.accentColor.opacity(0.5)).font(.custom("Poppins", size: 14)))
            } else {
                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.accentColor.opacity(0.5)).font(.custom("Poppins", size: 14)))
            }
        }
        .keyboardType(.emailAddress)
        .padding(16)
        .background(Color.base.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .inset(by: 0.5)
                .stroke(Color.accentColor.opacity(0.2), lineWidth: 1)
        )
    }
}

