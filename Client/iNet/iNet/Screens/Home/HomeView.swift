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
            Spacer()
        }
        .padding(.top, 24)
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
            Text("Daily Statistic")
                .font(.custom("Poppins-semibold", size: 18))
                .foregroundStyle(.accent)
            statisticCards
        }
    }
    
    private var statisticCards: some View {
        ScrollView(.horizontal) {
            HStack {
                statisticCard
                statisticCard
                statisticCard
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var statisticCard: some View {
        HStack(spacing: 8) {
            busIcon
            statisticText
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(width: 160, height: 64)
        .background(.base)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var busIcon: some View {
        ZStack {
            Circle()
                .frame(width: 44, height: 44)
                .foregroundStyle(.background.opacity(0.5))
            
            Image(systemName: "bus.fill")
                .resizable()
                .foregroundColor(.accent)
                .frame(width: 22, height: 22)
        }
    }
    
    private var statisticText: some View {
        VStack(alignment: .leading) {
            Text("293 340")
                .font(.custom("Poppins-bold", size: 14))
                .foregroundStyle(.accent)
            
            Text("Bus")
                .font(.custom("Poppins", size: 12))
                .foregroundStyle(.accent.opacity(0.6))
        }
    }
    
    
}

#Preview {
    HomeView()
}
