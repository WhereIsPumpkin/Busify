//
//  EmptyCardIllustrationView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 01.02.24.
//

import SwiftUI

struct EmptyCardIllustrationView: View {
    var body: some View {
        VStack(spacing: 32) {
            Image(.cardIllustration)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 84, height: 76)
                .font(.largeTitle)
            
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                   .symbolRenderingMode(.palette)
                   .font(.system(size: 24))
                   .foregroundStyle(Color.white, Color.alternate)
                
                Text("Add new card")
                    .font(.custom("Poppins-semibold", size: 16))
                    .foregroundStyle(.white)
            }
            
            HStack {
                Spacer()
            }
        }
        .padding(.top, 16)
        .background(Color.base .opacity(0.2))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 20).stroke(.accent.opacity(0.2),
                                                      lineWidth: 1))
    }
}


#Preview {
    EmptyCardIllustrationView()
}
