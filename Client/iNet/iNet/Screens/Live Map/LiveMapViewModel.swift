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
    func busArrivalTimesFetched(_ arrivalTimes: ArrivalTimesResponse, _ stopID: String)
    func busRouteFetched(_ route: Route)
    func busLocationsFetched(_ buses: [Bus])
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
            delegate?.busArrivalTimesFetched(arrivalTimes, stopID)
        } catch {
            delegate?.showError(error)
        }
    }
    
}

extension LiveMapViewModel {
    func fetchRouteAndBuses(for routeNumber: String, forward: Bool = true) async {
        do {
            let route = try await BusStopManager.shared.fetchBusRoute(routeNumber: routeNumber)
            delegate?.busRouteFetched(route)
            let buses = try await BusStopManager.shared.fetchCurrentBusLocations(routeNumber: routeNumber)
            delegate?.busLocationsFetched(buses)
        } catch {
            delegate?.showError(error)
        }
    }
}



