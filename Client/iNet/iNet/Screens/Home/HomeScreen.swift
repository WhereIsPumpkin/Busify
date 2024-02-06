//
//  HomeView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 29.01.24.
//

import SwiftUI

struct HomeScreen: View {
    // MARK: - Properties
    @StateObject var viewModel = HomeViewModel()
    @State private var user: User? = UserSessionManager.shared.currentUser
    @State private var showingErrorAlert = false
    @State private var isPurchasing = false
    
    var body: some View {
        ZStack {
            backgroundColor
            contentScroll
            purchasingAnimation
        }
        .onReceive(NotificationCenter.default.publisher(for: .didUpdateUser)) { _ in
            self.user = UserSessionManager.shared.currentUser
        }
        .alert(isPresented: $viewModel.showingErrorAlert) {
            Alert(title: Text("Error Notification"),
                  message: Text(viewModel.error ?? "An unknown error occurred."),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    private var backgroundColor: some View {
        Color.background.ignoresSafeArea()
    }
    
    private var purchasingAnimation: some View {
        Group {
            if isPurchasing {
                PurchaseAnimationOverlay()
                    .edgesIgnoringSafeArea(.all)
            }
        }
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
            Text(LocalizedStringKey("hello"))
                .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .regular).font(size: 18))
                .foregroundStyle(.accent)
            
            if let user = user {
                Text("\(user.name) \(user.lastName)")
                    .font(Font.custom("Poppins-bold", size: 18))
                    .foregroundStyle(.alternate)
            }
        }
    }
    
    private var dailyStatistic: some View {
        VStack(alignment: .leading, spacing: 16) {
            dailyStatisticTitle
            statisticCards
        }
    }
    
    private var dailyStatisticTitle: some View {
        Text(LocalizedStringKey("dailyStats"))
            .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .semibold).font(size: 18))
            .foregroundStyle(.accent)
    }
    
    private var statisticCards: some View {
        ScrollView(.horizontal) {
            HStack {
                if let stats = viewModel.passengerStatistic?.transactionsByTransportTypes {
                    StatisticCard(iconName: .busIcon, count: stats.bus.formattedWithSeparator(), transportType: "bus")
                    StatisticCard(iconName: .cableCar, count: stats.cableCar.formattedWithSeparator(), transportType: "cableCar")
                    StatisticCard(iconName: .minibus, count: stats.minibus.formattedWithSeparator(), transportType: "miniBus")
                    StatisticCard(iconName: .metro, count: stats.subway.formattedWithSeparator(), transportType: "subway")
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
            savedStopsTitle
            savedStopsView
        }
    }
    
    private var savedStopsView: some View {
        Group {
            if !viewModel.bookmarkedBusStops.isEmpty {
                savedStopList
            } else {
                emptyState
            }
        }
    }
    
    private var savedStopsTitle: some View {
        HStack {
            Text(LocalizedStringKey("savedStops"))
                .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .semibold).font(size: 18))
                .foregroundStyle(.accent)
            
            Image(systemName: "bookmark.fill")
                .foregroundStyle(.alternate.opacity(0.5))
        }
    }
    
    private var savedStopList: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.bookmarkedBusStops, id: \.id) { stop in
                    BusStopCard(busStopName: stop.name, busStopNumber: stop.code ?? "N/A")
                        .onTapGesture {
                            Task {
                                let arrivalTimes = try await viewModel.fetchBusStopArrivalTimes(stopID: stop.code ?? "0000")
                                NavigationManager.shared.navigateToBusStopDetailsPage(arrivalTimes: arrivalTimes, stopId: stop.code ?? "0000")
                            }
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(.busStopBrench)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
            
            VStack(spacing: 4) {
                Text(LocalizedStringKey("noTemplates"))
                    .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .semibold).font(size: 14))
                    .foregroundColor(.white)
                
                Text(LocalizedStringKey("templateDescription"))
                    .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .regular).font(size: 12))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.5))
            }
            
            HStack {
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
        .background(Color.base)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var travelCards: some View {
        VStack(alignment: .leading, spacing: 16) {
            travelCardText
            travelCard
        }
    }
    
    private var travelCardText: some View {
        VStack(alignment:. leading, spacing: 4) {
            Text(LocalizedStringKey("travelCard"))
                .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .semibold).font(size: 18))
                .foregroundColor(.white)
            
            Text(LocalizedStringKey("travel-description"))
                .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .regular).font(size: 11))
                .foregroundColor(Color(red: 0.87, green: 0.87, blue: 0.87).opacity(0.7))
                .frame(width: 240, alignment: .topLeading)
        }
    }
    
    private var travelCard: some View {
        ScrollView(.horizontal) {
            cardsStack
        }
        .scrollIndicators(.hidden)
    }
    
    private var cardsStack: some View {
        HStack(spacing: 8) {
            cardsForEach
        }
        .onReceive(viewModel.$error) { error in
            if error != nil {
                showingErrorAlert = true
            }
        }
    }
    
    private var cardsForEach: some View {
        ForEach(TransitCard.allCards) { card in
            TravelCard(cardName: card.cardName, price: card.price, duration: card.duration, descriptions: card.descriptions, viewModel: viewModel, isPurchasing: $isPurchasing)
        }
    }
}

#Preview {
    HomeScreen()
}
