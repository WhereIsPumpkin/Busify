//
//  HomeView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 29.01.24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            backgroundColor
            content
        }
    }
    
    private var backgroundColor: some View {
        Color.background.ignoresSafeArea()
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 32) {
            header
            dailyStatistic
            savedStops
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private var header: some View {
        HStack(spacing: 8) {
            profileImage
            welcomeText
            Spacer()
        }
    }
    
    private var profileImage: some View {
        Image(.profileImagePlaceholder)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 48, height: 48)
            .background(.white)
            .clipShape(Circle())
    }
    
    private var welcomeText: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Hello,")
                .font(Font.custom("Poppins-regular", size: 18))
                .foregroundStyle(.accent)
            
            Text("Thom Yorke")
                .font(Font.custom("Poppins-bold", size: 18))
                .foregroundStyle(.alternate)
        }
    }
    
    private var dailyStatistic: some View {
        VStack(alignment: .leading, spacing: 16) {
            dailyStatisticTitle
            statisticCards
        }
    }
    
    private var dailyStatisticTitle: some View {
        Text("Daily Statistic")
            .font(.custom("Poppins-semibold", size: 18))
            .foregroundStyle(.accent)
    }
    
    private var statisticCards: some View {
        ScrollView(.horizontal) {
            HStack {
                StatisticCard(iconName: "bus.fill", count: "293 340", transportType: "Bus")
                StatisticCard(iconName: "cablecar.fill", count: "4 145", transportType: "Cable car")
                StatisticCard(iconName: "bus.fill", count: "154 123", transportType: "Minibus")
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var savedStops: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Saved Stops")
                    .font(.custom("Poppins-semibold", size: 18))
                    .foregroundStyle(.accent)
                
                Image(systemName: "bookmark.fill")
                    .foregroundStyle(.alternate.opacity(0.5))
            }
            
            ScrollView(.horizontal) {
                HStack {
                    BusStopCard(busStopName: "გიორგი სააკაძის მოედანი", busStopNumber: "2446")
                    BusStopCard(busStopName: "გიორგი სააკაძის მოედანი", busStopNumber: "2446")
                    BusStopCard(busStopName: "გიორგი სააკაძის მოედანი", busStopNumber: "2446")
                    BusStopCard(busStopName: "გიორგი სააკაძის მოედანი", busStopNumber: "2446")
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    HomeView()
}
