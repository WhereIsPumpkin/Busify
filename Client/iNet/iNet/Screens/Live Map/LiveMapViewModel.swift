//
//  LiveMapViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 28.01.24.
//

import Foundation
import NetSwift

protocol LiveMapViewModelDelegate: AnyObject {
    func locationsFetched(_ locations: Locations)
    func busArrivalTimesFetched(_ stopID: ArrivalTimesResponse)
    func showError(_ error: Error)
}

final class LiveMapViewModel {
    // MARK: - Properties
    private var locations: Locations?
    private var selectedBusStopArrivalTimes: ArrivalTimesResponse?
    weak var delegate: LiveMapViewModelDelegate?
    
    func viewDidLoad() async {
        if BusStopManager.shared.getLocations() == nil {
            await BusStopManager.shared.fetchBusStops()
        }
        
        if let locations = BusStopManager.shared.getLocations() {
            self.delegate?.locationsFetched(locations)
        }
    }
    
    func fetchBusStopArrivalTimes(stopID: String) async {
        do {
            let arrivalTimes = try await BusStopManager.shared.fetchBusStopArrivalTimes(stopID: stopID)
            self.selectedBusStopArrivalTimes = arrivalTimes
            delegate?.busArrivalTimesFetched(arrivalTimes)
        } catch {
            delegate?.showError(error)
        }
    }
    
}

