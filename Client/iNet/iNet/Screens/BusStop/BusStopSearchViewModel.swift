//
//  BusScheduleViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 23.01.24.
//

import Foundation
import NetSwift

class BusStopSearchViewModel {
    // MARK: - Properties
    private var locations: Locations = []
    private var filteredLocations: Locations = []
    var selectedBusStopArrivalTimes: ArrivalTimesResponse?
    
    // MARK: Init
    init() {
        Task {
            await fetchBusStops()
        }
    }
    
    // MARK: - Stop Configure Methods
    func fetchBusStops() async {
        guard let url = URL(string: "http://transfer.ttc.com.ge:8080/otp/routers/ttc/index/stops") else { return }
        
        do {
            let fetchedData = try await NetworkManager.shared.fetchDecodableData(from: url, responseType: Locations.self)
            self.locations = fetchedData
            self.filteredLocations = fetchedData
        } catch {
            // TODO: - Error Handling
            print(error)
        }
    }
    
    func filterLocations(with query: String) {
        if query.isEmpty {
            filteredLocations = locations
        } else {
            filteredLocations = locations.filter { location in
                let queryLowercased = query.lowercased()
                let nameMatch = location.name.lowercased().contains(queryLowercased)
                let codeMatch = location.code?.lowercased().contains(queryLowercased) ?? false
                return nameMatch || codeMatch
            }
        }
    }
    
    var numberOfFilteredLocations: Int {
        return filteredLocations.count
    }
    
    func filteredLocation(at index: Int) -> Location {
        return filteredLocations[index]
    }
    
    // MARK: - Stop Details Methods
    func fetchBusStopArrivalTimes(stopID: String, completion: @escaping () -> Void) async throws {
        let urlString = "https://transfer.msplus.ge:1443/otp/routers/ttc/stopArrivalTimes?stopId=\(stopID)"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        let arrivalTimes = try await NetworkManager.shared.fetchDecodableData(from: url, responseType: ArrivalTimesResponse.self)
        self.selectedBusStopArrivalTimes = arrivalTimes
        completion()
    }
    
}
