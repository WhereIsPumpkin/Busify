//
//  BusStopManager.swift
//  iNet
//
//  Created by Saba Gogrichiani on 31.01.24.
//

import Foundation
import NetSwift

final class BusStopManager {
    static let shared = BusStopManager()
    private var locations: Locations?
    
    private init() {}
    
    func fetchBusStops() async {
        guard let url = URL(string: "http://transfer.ttc.com.ge:8080/otp/routers/ttc/index/stops") else { return }
        print("I'm from bus manager making call")
        do {
            let fetchedData = try await NetworkManager.shared.fetchDecodableData(from: url, responseType: Locations.self)
            self.locations = fetchedData
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
        return try await NetworkManager.shared.fetchDecodableData(from: url, responseType: ArrivalTimesResponse.self)
    }
    
    func toggleBookmark(busStopID: String) async -> Void {
        guard let url = URL(string: "\(baseURL.production.rawValue)/api/bookmark/toggle") else { return }
        
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            return
        }
        
        guard let userID = UserSessionManager.shared.currentUser?.id else { return }
        
        let requestBody = BookmarkToggleRequest(busStopID: busStopID, userID: userID)
        guard let httpBody = try? JSONEncoder().encode(requestBody) else {
            print("Failed to encode request body")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let str = String(data: data, encoding: .utf8)
            print("Received data:\n\(str ?? "")")
            await UserSessionManager.shared.fetchUserInfo()
        } catch {
            print("Error: \(error)")
        }
    }
}

