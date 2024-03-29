//
//  StatisticCard.swift
//  iNet
//
//  Created by Saba Gogrichiani on 29.01.24.
//

import SwiftUI

struct StatisticCard: View {
    let iconName: ImageResource
    let count: String
    let transportType: String

    var body: some View {
        HStack(spacing: 8) {
            busIcon
            statisticText
            Spacer()
        }
        .padding(.leading, 16)
        .padding(.trailing, 8)
        .frame(width: 160, height: 64)
        .background(.base)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var busIcon: some View {
        ZStack {
            Circle()
                .frame(width: 44, height: 44)
                .foregroundStyle(.background.opacity(0.5))
            
            Image(iconName)
                .resizable()
                .foregroundColor(.accent)
                .frame(width: 22, height: 22)
        }
    }
    
    private var statisticText: some View {
        VStack(alignment: .leading) {
            Text(count)
                .font(.custom("Poppins-bold", size: 14))
                .foregroundStyle(.accent)
            
            Text(LocalizedStringKey(transportType))
                .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .regular).font(size: 12))
                .foregroundStyle(.accent.opacity(0.6))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}
