//
//  OTPTextField.swift
//  iNet
//
//  Created by Saba Gogrichiani on 17.01.24.
//

import SwiftUI

struct OTPTextField: View {
    let numberOfFields: Int
    @Binding var enterValue: [String]
    @FocusState private var fieldFocus: Int?
    @State private var oldValue = ""
    
    init(numberOfFields: Int, enterValue: Binding<[String]>) {
        self.numberOfFields = numberOfFields
        self._enterValue = enterValue
    }
    
    var body: some View {
        HStack {
            ForEach(0..<numberOfFields, id: \.self) { index in
                TextField("", text: $enterValue[index], onEditingChanged: { editing in
                    
                    if editing {
                        oldValue = enterValue[index]
                    }
                })
                .keyboardType(.numberPad)
                .frame(width: 56, height: 56)
                .background(Color(red: 0.44, green: 0.44, blue: 0.44).opacity(0.03))
                .multilineTextAlignment(.center)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 0.44, green: 0.44, blue: 0.44).opacity(0.3), lineWidth: 1)
                )
                .focused($fieldFocus, equals: index)
                .tag(index)
                .onChange(of: enterValue[index]) { _, newValue in
                    if enterValue[index].count > 1 {
                        let currentValue = Array(enterValue[index])
                        if currentValue[0] == Character(oldValue) {
                            enterValue[index] = String(enterValue[index].suffix(1))
                        } else {
                            enterValue[index] = String(enterValue[index].prefix(1))
                        }
                    }
                    if !newValue.isEmpty {
                        if index == numberOfFields - 1 {
                            fieldFocus = nil
                        } else {
                            fieldFocus = (fieldFocus ?? 0) + 1
                        }
                    } else {
                        fieldFocus = (fieldFocus ?? 0) - 1
                    }
                    
                }
                
                if index != 3 {
                    Spacer()
                }
            }
        }
        .padding(.top, 8)
    }
}
