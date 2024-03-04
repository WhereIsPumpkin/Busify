//
//  BusStopManager.swift
//  iNet
//
//  Created by Saba Gogrichiani on 31.01.24.
//

import Foundation
import NetSwiftly

final class BusStopManager {
    static let shared = BusStopManager()
    private var locations: Locations?
    
    private init() {}
    
    func fetchBusStops() async {
        guard let url = URL(string: "http://transfer.ttc.com.ge:8080/otp/routers/ttc/index/stops") else { return }
        let request = URLRequestBuilder(baseURL: url).get("")
        
        do {
            let fetchedData = try await NetSwiftly.shared.performRequest(request: request, responseType: Locations.self)
            self.locations = fetchedData
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .didUpdateUser, object: nil)
            }
        } catch {
            print("Error fetching bus stops: \(error)")
        }
    }
    
    func getLocations() -> Locations? {
        return self.locations
    }
    
    func filterLocations(with query: String) -> Locations {
        guard let locations = self.locations else { return [] }
        if query.isEmpty {
            return locations
        } else {
            return locations.filter { location in
                let queryLowercased = query.lowercased()
                let nameMatch = location.name.lowercased().contains(queryLowercased)
                let codeMatch = location.code?.lowercased().contains(queryLowercased) ?? false
                return nameMatch || codeMatch
            }
        }
    }
    
    func fetchBusStopArrivalTimes(stopID: String) async throws -> ArrivalTimesResponse {
        let urlString = "https://transfer.msplus.ge:1443/otp/routers/ttc/stopArrivalTimes?stopId=\(stopID)"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        let request = URLRequestBuilder(baseURL: url).get("")
        
        return try await NetSwiftly.shared.performRequest(request: request, responseType: ArrivalTimesResponse.self)
    }
    
    func toggleBookmark(busStopID: String) async -> Void {
        let url = BaseURL.production.url
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        guard let userID = UserSessionManager.shared.currentUser?.id else { return }
        let requestBody = BookmarkToggleRequest(busStopID: busStopID, userID: userID)
        
        var request = URLRequestBuilder(baseURL: url).post("/api/bookmark/toggle")
        request.setBearerToken(token)
            
        do {
            try request.setJSONBody(requestBody)
            _ = try await NetSwiftly.shared.performRequest(request: request, responseType: Empty.self)
            await UserSessionManager.shared.fetchUserInfo()
        } catch {
            print("Error: \(error)")
        }
    }
}

extension BusStopManager {
    func fetchBusRoute(routeNumber: String) async throws -> Route {
        let urlString = "https://transfer.msplus.ge:1443/otp/routers/ttc/routeInfo?routeNumber=\(routeNumber)&type=bus"
        let url = URL(string: urlString)!
        let request = URLRequestBuilder(baseURL: url).get("")
        return try await NetSwiftly.shared.performRequest(request: request, responseType: Route.self)
    }
    
    func fetchCurrentBusLocations(routeNumber: String) async throws -> [Bus] {
        let urlString = "https://transfer.msplus.ge:1443/otp/routers/ttc/buses?routeNumber=\(routeNumber)"
        let url = URL(string: urlString)!
        let request = URLRequestBuilder(baseURL: url).get("")
        let busResponse = try await NetSwiftly.shared.performRequest(request: request, responseType: BusResponse.self)
        return busResponse.bus
    }
}
