//
//  StyledTextField.swift
//  iNet
//
//  Created by Saba Gogrichiani on 16.01.24.
//

import SwiftUI

struct StyledTextField: View {
    @Binding var text: String
    var prompt: String
    var isSecure: Bool

    var body: some View {
        Group {
            if isSecure {
                SecureField("", text: $text, prompt: Text(prompt).foregroundColor(.gray))
            } else {
                TextField("", text: $text, prompt: Text(prompt).foregroundColor(.gray))
            }
        }
        .keyboardType(.emailAddress)
        .padding(16)
        .background(Color(red: 0.44, green: 0.44, blue: 0.44).opacity(0.03))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .inset(by: 0.5)
                .stroke(Color(red: 0.44, green: 0.44, blue: 0.44).opacity(0.05), lineWidth: 1)
        )
    }
}

