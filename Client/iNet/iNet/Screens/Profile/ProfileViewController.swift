//
//  ProfileViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit
import NetSwift

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        Task {
            do {
                let result = try await fetchBusStopArrivalTimes(stopID: "4269")
                print(result.arrivalTime[0].routeNumber)
            } catch {
                print(error)
            }
        }
    }
    
    func fetchBusStopArrivalTimes(stopID: String) async throws -> ArrivalTimesResponse {
        let urlString = "https://transfer.msplus.ge:1443/otp/routers/ttc/stopArrivalTimes?stopId=\(stopID)"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        
        let arrivalTimes: ArrivalTimesResponse = try await NetworkManager.shared.fetchDecodableData(from: url, responseType: ArrivalTimesResponse.self)
        return arrivalTimes
    }
    
}
