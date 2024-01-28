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
        await fetchBusStops()
    }
    
    private func fetchBusStops() async {
        guard let url = URL(string: "http://transfer.ttc.com.ge:8080/otp/routers/ttc/index/stops") else { return }
        
        do {
            let fetchedData = try await NetworkManager.shared.fetchDecodableData(from: url, responseType: Locations.self)
            self.locations = fetchedData
            self.delegate?.locationsFetched(fetchedData)
        } catch {
            self.delegate?.showError(error)
        }
    }
    
    func fetchBusStopArrivalTimes(stopID: String) async {
        guard let url = URL(string: "https://transfer.msplus.ge:1443/otp/routers/ttc/stopArrivalTimes?stopId=\(stopID)") else { return }
        
        do {
            let arrivalTimes = try await NetworkManager.shared.fetchDecodableData(from: url, responseType: ArrivalTimesResponse.self)
            self.selectedBusStopArrivalTimes = arrivalTimes
            delegate?.busArrivalTimesFetched(arrivalTimes)
        } catch {
            delegate?.showError(error)
        }
    }

}

