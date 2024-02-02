//
//  CardView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 02.02.24.
//

import SwiftUI

struct CardView: View {
    
    let card: Card
    
    var body: some View {
        HStack(alignment: .bottom) {
            cardInfo
            Spacer()
            Image(.mastercard)
                .resizable()
                .scaledToFill()
                .frame(width: 76, height: 76)
        }
        .padding(.top, 20)
        .padding(.leading, 24)
        .padding(.trailing, 8)
        .padding(.bottom, 8)
        .frame(height: 182)
        .background(Color.alternate)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var cardInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            cardNumberStack
            cardNameAndDate
            Spacer()
        }
    }
    
    private var cardNumberStack: some View {
        VStack(alignment: .leading, spacing: 32) {
            Text("iBank")
                .foregroundStyle(.white)
                .font(.custom("Poppins-bold", size: 18))
            
            Text(card.cardNumber ?? "")
                .foregroundStyle(.white)
                .font(.custom("Poppins-bold", size: 18))
        }
    }
    
    private var cardNameAndDate: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(card.cardName ?? "")
                .foregroundStyle(.white)
                .font(.custom("Poppins-bold", size: 16))
            
            Text("Exp \(card.cardDate ?? "N/A")")
                .foregroundStyle(Color(red: 224/255, green: 202/255, blue: 202/255))
                .font(.custom("Poppins-bold", size: 16))
        }
    }
    
}

#Preview {
    CardView(card: Card(cardNumber: "1313 1234 1234 1234", cardName: "John Doe", cardDate: "06/25"))
}
