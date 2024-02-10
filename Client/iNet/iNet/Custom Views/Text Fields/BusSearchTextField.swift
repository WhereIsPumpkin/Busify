//
//  BusSearchTextField.swift
//  iNet
//
//  Created by Saba Gogrichiani on 08.02.24.
//

import SwiftUI

struct BusSearchTextField: View {

    @State var text = ""
    var onSearch: (String) -> Void
    var onResend: () -> Void
    
    var body: some View {
        HStack {
            textField
            resendButton
        }
    }
    
    private var textField: some View {
        HStack {
            Image(.busIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
            
            TextField("", text: $text, prompt: Text("321"))
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
            
            Image(systemName: "magnifyingglass")
                .resizable()
                .foregroundStyle(.white)
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.accentColor.opacity(0.4), lineWidth: 1)
                        .frame(width: 40, height: 40)
                )
                .onTapGesture {
                    onSearch(text)
                }
        }
        .padding(.horizontal, 12)
        .frame(width: 160, height: 40)
        .background(.base)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.accentColor.opacity(0.4), lineWidth: 1)
        )
    }
    
    private var resendButton: some View {
        Button(action: {
            onResend()
        }, label: {
            Image(systemName: "arrow.triangle.2.circlepath")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
        })
        .frame(width: 40, height: 40)
        .background(Color.base)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.accentColor.opacity(0.4), lineWidth: 1)
        )
    }
}

#Preview {
    BusSearchTextField(onSearch: {_ in }, onResend: {})
}
