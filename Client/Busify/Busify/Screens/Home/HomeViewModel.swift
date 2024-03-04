//
//  HomeViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 30.01.24.
//

import Foundation
import NetSwiftly

final class HomeViewModel: ObservableObject {
    @Published var passengerStatistic: TransactionsResponse?
    @Published var error: String?
    @Published var showingErrorAlert = false
    @Published var bookmarkedBusStops: [Location] = []
    let baseURL = BaseURL.production.url
    
    init() {
        Task {
            await fetchData()
            setupBookmarkObserver()
        }
    }
    
    private func fetchData() async {
        await fetchPassengersData()
        await fetchBookmarkedBusStops()
    }
    
    private func setupBookmarkObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(cardUpdatedNotificationReceived(_:)), name: .didUpdateUser, object: nil)
    }
    
    @objc private func cardUpdatedNotificationReceived(_ notification: Notification) {
        Task {
            await fetchBookmarkedBusStops()
        }
    }
    
    private func fetchPassengersData() async {
        do {
            guard let url = URL(string: "https://ttc.com.ge/api") else {
                throw URLError(.badURL)
            }
            let builder = URLRequestBuilder(baseURL: url).get("/passengers")
            let passengerCount = try await NetSwiftly.shared.performRequest(request: builder, responseType: TransactionsResponse.self)
            DispatchQueue.main.async {
                self.passengerStatistic = passengerCount
            }
        } catch {
            await handleError(error)
        }
    }
    
    private func fetchBookmarkedBusStops() async {
        guard let bookmarkedIds = UserSessionManager.shared.currentUser?.bookmarkedStops,
              let allStops = BusStopManager.shared.getLocations() else {
            DispatchQueue.main.async {
                self.bookmarkedBusStops = []
            }
            return
        }
        
        let filteredStops = allStops.filter { location in
            bookmarkedIds.contains(where: { $0 == location.code })
        }
        
        DispatchQueue.main.async {
            self.bookmarkedBusStops = filteredStops
        }
    }
    
    func fetchBusStopArrivalTimes(stopID: String) async throws -> ArrivalTimesResponse {
        return try await BusStopManager.shared.fetchBusStopArrivalTimes(stopID: stopID)
    }
    
    func buyTicket(card: TransitCard) async -> Void {
        
        var builder = URLRequestBuilder(baseURL: baseURL).post("/api/ticket/buy")
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        let body = BuyTicketRequest(cardName: card.cardName, price: card.price, duration: card.duration)
        
        do {
            builder.setBearerToken(token)
            try builder.setJSONBody(body)
            let _ = try await NetSwiftly.shared.performRequest(request: builder, responseType: Empty.self)
            let _ = await UserSessionManager.shared.fetchUserInfo()
        } catch {
            await handleError(error)
        }
        
    }
}

extension HomeViewModel {
    @MainActor
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .serverMessage(let message):
                self.error = message
            default:
                self.error = "An unexpected network error occurred."
            }
        } else {
            self.error = error.localizedDescription
        }
        self.showingErrorAlert = true
    }
}

