//
//  HomeViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 30.01.24.
//

import Foundation
import Combine
import NetSwift

final class HomeViewModel: ObservableObject {
    // MARK: - Properties
    @Published var passengerStatistic: TransactionsResponse?
    @Published var error: String?
    @Published var bookmarkedBusStops: [Location] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Task {
            await fetchPassengersData()
            await fetchBookmarkedBusStops()
        }
        
        setupBookmarkObserver()
    }
    
    private func setupBookmarkObserver() {
        let weakViewModel = Weak(self)
        NotificationCenter.default.publisher(for: .bookmarksUpdated)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                Task {
                    guard let strongSelf = weakViewModel.value else { return }
                    await strongSelf.fetchBookmarkedBusStops()
                }
            }
            .store(in: &cancellables)
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
        
        if BusStopManager.shared.getLocations() == nil {
            try? await Task.sleep(nanoseconds: 500_000_000)
            await fetchBookmarkedBusStops()
            return
        }
        
        guard let bookmarkedIds = UserSessionManager.shared.currentUser?.bookmarkedStops else {
            DispatchQueue.main.async {
                self.bookmarkedBusStops = []
            }
            return
        }
        guard let allStops = BusStopManager.shared.getLocations() else {
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
        do {
            let arrivalTimes = try await BusStopManager.shared.fetchBusStopArrivalTimes(stopID: stopID)
            return arrivalTimes
        } catch {
            throw error
        }
    }
}

private struct Weak<T: AnyObject> {
    weak var value: T?
    init(_ value: T) {
        self.value = value
    }
}
