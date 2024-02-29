//
//  BusStopCard.swift
//  iNet
//
//  Created by Saba Gogrichiani on 30.01.24.
//

import SwiftUI

struct BusStopCard: View {
    let busStopName: String
    let busStopNumber: String

    var body: some View {
        VStack(spacing: 8) {
            busIcon
            busInfo
        }
        .padding(8)
        .frame(width: 112, height: 120)
        .background(Color.base)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var busIcon: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 42, height: 42)
                .background(Color.alternate.opacity(0.5))
                .cornerRadius(12)
            
            Image(.busStopIcon)
                .resizable()
                .foregroundColor(.accent)
                .frame(width: 24, height: 24)
        }
    }
    
    private var busInfo: some View {
        VStack(spacing: 2) {
            Text(busStopName)
                .font(.custom("Poppins", size: 10).weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.accent)
            
            Text("[\(busStopNumber)]")
                .font(.custom("Poppins", size: 10).weight(.medium))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    
}

#Preview {
    BusStopCard(busStopName: "პეტრე იბერის ქ.", busStopNumber: "2993")
}
