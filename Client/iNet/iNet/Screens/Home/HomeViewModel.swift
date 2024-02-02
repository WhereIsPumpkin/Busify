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
    @Published var passengerStatistic: TransactionsResponse?
    @Published var error: String?
    @Published var bookmarkedBusStops: [Location] = []

    private var cancellables = Set<AnyCancellable>()

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
        NotificationCenter.default.publisher(for: .didUpdateUser)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                Task {
                    await self.fetchBookmarkedBusStops()
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
}

