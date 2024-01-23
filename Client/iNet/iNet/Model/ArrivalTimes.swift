//
//  ArrivalTimes.swift
//  iNet
//
//  Created by Saba Gogrichiani on 22.01.24.
//

import Foundation

struct ArrivalTimesResponse: Decodable {
    let arrivalTime: [ArrivalTime]

    enum CodingKeys: String, CodingKey {
        case arrivalTime = "ArrivalTime"
    }
}

struct ArrivalTime: Decodable {
    let routeNumber: String
    let destinationStopName: String
    let arrivalTime: Int

    enum CodingKeys: String, CodingKey {
        case routeNumber = "RouteNumber"
        case destinationStopName = "DestinationStopName"
        case arrivalTime = "ArrivalTime"
    }
}


