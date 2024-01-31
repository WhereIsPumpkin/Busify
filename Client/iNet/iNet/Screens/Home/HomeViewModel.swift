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

    init() {
        Task {
            await fetchPassengersData()
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

}
