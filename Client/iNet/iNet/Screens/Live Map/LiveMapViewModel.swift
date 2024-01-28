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
    func showError(_ error: Error)
}

final class LiveMapViewModel {
    // MARK: - Properties
    private var locations: Locations?
    weak var delegate: LiveMapViewModelDelegate?
    
    func viewDidLoad() async {
        await fetchBusStops()
    }
    
    func fetchBusStops() async {
        guard let url = URL(string: "http://transfer.ttc.com.ge:8080/otp/routers/ttc/index/stops") else { return }
        
        do {
            let fetchedData = try await NetworkManager.shared.fetchDecodableData(from: url, responseType: Locations.self)
            self.locations = fetchedData
            self.delegate?.locationsFetched(fetchedData)
        } catch {
            // TODO: - Error Handling
            print(error)
        }
    }
}

