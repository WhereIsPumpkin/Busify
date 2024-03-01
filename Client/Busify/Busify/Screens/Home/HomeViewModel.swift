//
//  HomeViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 30.01.24.
//

import Foundation
import NetSwift

final class HomeViewModel: ObservableObject {
    @Published var passengerStatistic: TransactionsResponse?
    @Published var error: String?
    @Published var showingErrorAlert = false
    @Published var bookmarkedBusStops: [Location] = []
    
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
            guard let url = URL(string: "https://ttc.com.ge/api/passengers") else {
                throw URLError(.badURL)
            }
            let passengerCount = try await NetworkManager.shared.fetchDecodableData(from: url, responseType: TransactionsResponse.self)
            DispatchQueue.main.async {
                self.passengerStatistic = passengerCount
            }
        } catch let fetchError {
            updateError(error as! Error)
            DispatchQueue.main.async {
                self.error = fetchError.localizedDescription
            }
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
        guard let url = URL(string: "\(BaseURL.production.rawValue)/api/ticket/buy") else { return }
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        let headers: [String: String] = ["Authorization": "Bearer \(token)", "Content-Type": "application/json"]
        
        let body = BuyTicketRequest(cardName: card.cardName, price: card.price, duration: card.duration)
        
        do {
            let _ = try await NetworkManager.shared.postDataWithHeaders(to: url, body: body, headers: headers)
            let _ = await UserSessionManager.shared.fetchUserInfo()
        } catch {
            updateError(error)
        }
        
    }
    
    func updateError(_ error: Error) {
        DispatchQueue.main.async {
            if let networkError = error as? NetSwift.NetworkError,
               case let .backendError(backendError) = networkError {
                self.error = backendError.message
            } else {
                self.error = error.localizedDescription
            }
            self.showingErrorAlert = true
        }
    }
}

