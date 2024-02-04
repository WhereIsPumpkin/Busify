//
//  TravelCard.swift
//  iNet
//
//  Created by Saba Gogrichiani on 30.01.24.
//

import SwiftUI

struct TravelCard: View {
    // MARK: - Properties
    let cardName: String
    let price: Int
    let duration: String
    let descriptions: [String]
    @ObservedObject var viewModel: HomeViewModel
    @Binding var isPurchasing: Bool
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            serviceInfo
            description
            buyButton
            Spacer()
        }
        .background(.base)
        .frame(width: 160, height: 198)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var serviceInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            title
            priceInfo
        }
        .padding(.leading, 16)
        .frame(height: 90)
        .background(.alternate)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var title: some View {
        Text(cardName)
            .font(.custom("Poppins-semibold", size: 14))
            .foregroundStyle(.white)
    }
    
    private var priceInfo: some View {
        HStack(spacing: 4) {
            priceView
            durationView
            Spacer()
        }
    }
    
    private var priceView: some View {
        HStack(alignment: .top, spacing: 4) {
            Text("₾")
                .font(.custom("Poppins-semibold", size: 16))
                .foregroundStyle(.white)
                .padding(.top, 4)
            
            Text(String(price))
                .font(.custom("Poppins-bold", size: 32))
                .minimumScaleFactor(0.4)
                .foregroundStyle(.white)
            
        }
    }
    
    private var durationView: some View {
        Text("/\(duration)")
            .font(.custom("Poppins-medium", size: 12))
            .padding(.top, 10)
            .lineLimit(0)
            .minimumScaleFactor(0.8)
            .foregroundColor(Color(red: 0.84, green: 0.81, blue: 0.81))
    }
    
    private var description: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(descriptions, id: \.self) { desc in
                Label(desc, systemImage: "checkmark.circle")
                    .font(.custom("Poppins-semibold", size: 10))
                    .foregroundColor(Color(red: 0.87, green: 0.87, blue: 0.87))
            }
        }
        .padding(16)
    }
    
    private var buyButton: some View {
        Button(action: {
            isPurchasing = true
            Task {
                await viewModel.buyTicket(card: TransitCard(cardName: cardName,
                                                            price: price,
                                                            duration: duration,
                                                            descriptions: descriptions))
                isPurchasing = false
            }
        }, label: {
            Text("Buy")
                .frame(width: 64, height: 24)
                .background(Color.alternate)
                .font(.custom("Poppins-semibold", size: 10))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
        })
        .padding(.horizontal, 16)
    }
}

#Preview {
    TravelCard(cardName: "MetroQuickaasd", price: 250, duration: "Semiannual", descriptions: ["90-Minute Freedom", "Brief adventure"], viewModel: HomeViewModel(), isPurchasing: .constant(false))
}
