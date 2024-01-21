//
//  ServicesViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit
import NetSwift

class ServicesViewModel {
    struct ServiceItem {
        let type: ServiceType
    }
    
    let serviceItems: [ServiceItem] = ServiceType.allCases.map { ServiceItem(type: $0) }
    
    private var locations: Locations = []
    private var filteredLocations: Locations = []
    
    init() {
        Task {
            await fetchBusStops { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error fetching bus stops: \(error)")
                    } else {
                        self?.filteredLocations = self?.locations ?? []
                    }
                }
            }
        }
    }
    
    func fetchBusStops(completion: @escaping (Error?) -> Void) async {
        let url = URL(string: "http://transfer.ttc.com.ge:8080/otp/routers/ttc/index/stops")!
        do {
            let fetchedData: Locations = try await NetworkManager.shared.fetchDecodableData(from: url, responseType: Locations.self)
            self.locations = fetchedData
            completion(nil)
        } catch {
            completion(error)
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
}

