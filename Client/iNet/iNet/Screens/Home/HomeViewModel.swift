//
//  HomeViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 30.01.24.
//

import Foundation
import NetSwift

final class HomeViewModel: ObservableObject {
    // MARK: - Properties
    @Published var passengerStatistic: TransactionsResponse?
    @Published var error: String?
    @Published var bookmarkedBusStops: [Location] = []
    
    init() {
        Task {
            await fetchPassengersData()
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
            DispatchQueue.main.async {
                self.error = fetchError.localizedDescription
            }
        }
    }
    
    private func fetchBookmarkedBusStops() async {
        guard let bookmarkedIds = UserSessionManager.shared.currentUser?.bookmarkedStops else {
            self.bookmarkedBusStops = []
            return
        }
        guard let allStops = BusStopManager.shared.getLocations() else {
            self.bookmarkedBusStops = []
            return
        }
        
        DispatchQueue.main.async {
            self.bookmarkedBusStops = allStops.filter { location in
                bookmarkedIds.contains(where: { $0 == location.code })
            }
        }
    }
    
}
