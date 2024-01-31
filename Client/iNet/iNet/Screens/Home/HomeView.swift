//
//  HomeView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 29.01.24.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            backgroundColor
            contentScroll
        }
    }
    
    private var backgroundColor: some View {
        Color.background.ignoresSafeArea()
    }
    
    private var contentScroll: some View {
        ScrollView {
            content
        }
        .padding(.top, 1)
        .scrollIndicators(.hidden)
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 32) {
            header
            dailyStatistic
            savedStops
            travelCards
            Spacer()
        }
        .padding(.top, 8)
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
                if let stats = viewModel.passengerStatistic?.transactionsByTransportTypes {
                    StatisticCard(iconName: .busIcon, count: stats.bus.formattedWithSeparator(), transportType: "Bus")
                    StatisticCard(iconName: .cableCar, count: stats.cableCar.formattedWithSeparator(), transportType: "Cable car")
                    StatisticCard(iconName: .minibus, count: stats.minibus.formattedWithSeparator(), transportType: "Minibus")
                    StatisticCard(iconName: .metro, count: stats.subway.formattedWithSeparator(), transportType: "Subway")
                } else {
                    statisticEmptyState
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var statisticEmptyState: some View {
        HStack(spacing: 16) {
            Text("Loading statistics...")
                .font(.custom("Poppins-semibold", size: 12))
                .foregroundStyle(.accent)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1)
                .tint(Color.accentColor)
        }
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
    
    private var travelCards: some View {
        VStack(alignment: .leading, spacing: 16) {
            travelCardText
            travelCard
        }
    }
    
    private var travelCardText: some View {
        VStack(alignment:. leading, spacing: 4) {
            Text("Travel card")
                .font(.custom("Poppins-semibold", size: 18))
                .foregroundColor(.white)
            
            Text("Select your ideal Travel Card for enjoyable public transport in Tbilisi.")
                .font(Font.custom("Poppins", size: 11))
                .foregroundColor(Color(red: 0.87, green: 0.87, blue: 0.87).opacity(0.7))
                .frame(width: 240, alignment: .topLeading)
        }
    }
    
    private var travelCard: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                TravelCard(cardName: "MetroQuick", price: 1, duration: "90min", descriptions: [
                    "90-Minute Freedom", "Brief adventure"
                ])
                TravelCard(cardName: "MetroDay", price: 3, duration: "Daily", descriptions: [
                    "All-Day Access", "Tourist's Favorite"
                ])
                TravelCard(cardName: "MetroWeek", price: 20, duration: "Weekly", descriptions: [
                    "Week-Long Travel", "7-Day Explorer"
                ])
                TravelCard(cardName: "MetroMonth", price: 40, duration: "Monthly", descriptions: [
                    "Monthly Commuter", "30-Day Pass"
                ])
                TravelCard(cardName: "MetroSeasonal", price: 100, duration: "Quarterly", descriptions: [
                    "Quarter-Year Tour", "Seasonal Freedom"
                ])
                TravelCard(cardName: "MetroBiannual", price: 150, duration: "Semiannual", descriptions: [
                    "Six-Month Journey", "Half-Year Pass"
                ])
                TravelCard(cardName: "MetroYearly", price: 250, duration: "Annual", descriptions: [
                    "Year-Round Travel", "Annual Unlimited"
                ])
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    HomeView()
}
