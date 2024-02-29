//
//  BusScheduleViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 23.01.24.
//

import Foundation
import NetSwift

final class BusStopSearchViewModel {
    // MARK: - Properties
    private var filteredLocations: Locations = []
    var selectedBusStopArrivalTimes: ArrivalTimesResponse?
    
    // MARK: - Initialization
    init() {
        Task {
            await initializeBusStops()
        }
    }
    
    // MARK: - Stop Configure Methods
    private func initializeBusStops() async {
        if BusStopManager.shared.getLocations() == nil {
            await BusStopManager.shared.fetchBusStops()
        }
        self.filteredLocations = BusStopManager.shared.getLocations() ?? []
    }
    
    func filterLocations(with query: String) {
        filteredLocations = BusStopManager.shared.filterLocations(with: query)
    }
    
    var numberOfFilteredLocations: Int {
        return filteredLocations.count
    }
    
    func filteredLocation(at index: Int) -> Location {
        return filteredLocations[index]
    }
    
    // MARK: - Stop Details Methods
    func fetchBusStopArrivalTimes(stopID: String, completion: @escaping () -> Void) async {
        do {
            let arrivalTimes = try await BusStopManager.shared.fetchBusStopArrivalTimes(stopID: stopID)
            self.selectedBusStopArrivalTimes = arrivalTimes
            completion()
        } catch {
            print("Error fetching bus stop arrival times: \(error.localizedDescription)")
        }
    }
}
