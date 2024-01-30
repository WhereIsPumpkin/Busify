//
//  TravelCard.swift
//  iNet
//
//  Created by Saba Gogrichiani on 30.01.24.
//

import SwiftUI

struct TravelCard: View {
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
        .padding(.horizontal, 16)
        .frame(height: 90)
        .background(.alternate)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var title: some View {
        Text("MetroQuick")
            .font(.custom("Poppins-semibold", size: 14))
            .foregroundStyle(.white)
    }
    
    private var priceInfo: some View {
        HStack(spacing: 4) {
            price
            duration
            Spacer()
        }
    }
    
    private var price: some View {
        HStack(alignment: .top, spacing: 4) {
            Text("₾")
                .font(.custom("Poppins-semibold", size: 16))
                .foregroundStyle(.white)
                .padding(.top, 4)
            
            Text("1")
                .font(.custom("Poppins-bold", size: 32))
                .foregroundStyle(.white)
            
        }
    }
    
    private var duration: some View {
        Text("/90min")
            .font(.custom("Poppins-medium", size: 12))
            .padding(.top, 10)
            .foregroundColor(Color(red: 0.84, green: 0.81, blue: 0.81))
    }
    
    private var description: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("90-Minute Freedom", systemImage: "checkmark.circle")
                .font(.custom("Poppins-semibold", size: 10))
                .foregroundColor(Color(red: 0.87, green: 0.87, blue: 0.87))

            Label("Brief adventure", systemImage: "checkmark.circle")
                .font(.custom("Poppins-semibold", size: 10))
                .foregroundColor(Color(red: 0.87, green: 0.87, blue: 0.87))
        }
        .padding(16)
    }
    
    private var buyButton: some View {
        Button(action: {
            // TODO: - Buy Action
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
    TravelCard()
}
