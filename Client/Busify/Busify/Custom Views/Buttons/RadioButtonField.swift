//
//  RadioButtonField.swift
//  iNet
//
//  Created by Saba Gogrichiani on 16.01.24.
//

import SwiftUI

struct RadioButtonField: View {
    let id: String
    let label: String
    let isMarked: Bool
    let callback: (String) -> ()

    var body: some View {
        Button(action: {
            callback(id)
        }) {
            HStack {
                Text(label)
                    .font(Font.custom("Poppins", size: 16))
                Spacer()
                Image(systemName: isMarked ? "largecircle.fill.circle" : "circle")
                    .renderingMode(.original)
                    .resizable()
                    .foregroundStyle(Color("mainColor"))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            }
        }
        .foregroundColor(Color.black)
    }
}
