//
//  LiveMapViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 28.01.24.
//

import Foundation
import NetSwift

class LiveMapViewModel {
    var locations: Locations = []
    
    func fetchBusStops() async {
        guard let url = URL(string: "http://transfer.ttc.com.ge:8080/otp/routers/ttc/index/stops") else { return }
        
        do {
            let fetchedData = try await NetworkManager.shared.fetchDecodableData(from: url, responseType: Locations.self)
            self.locations = fetchedData
        } catch {
            // TODO: - Error Handling
            print(error)
        }
    }
}

