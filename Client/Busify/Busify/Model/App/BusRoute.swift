//
//  BusRoute.swift
//  iNet
//
//  Created by Saba Gogrichiani on 07.02.24.
//

import Foundation

struct Route: Codable {
    var Id: String?
    var RouteNumber: String?
    var LongName: String?
    var Color: String?
    var Shape: String?
    var routeStops: [RouteStop]?
}

struct RouteStop: Codable {
    var Forward: Bool
    var HasBoard: Bool
    var Lat: Double
    var Lon: Double
    var Name: String
    var Sequence: Int
    var StopId: String
    var Virtual: Bool
}

struct Bus: Codable {
    var forward: Bool
    var lat: Double
    var lon: Double
    var nextStopId: String
    var routeNumber: String
    
    enum CodingKeys: String, CodingKey {
        case forward = "forward"
        case lat = "lat"
        case lon = "lon"
        case nextStopId = "nextStopId"
        case routeNumber = "routeNumber"
    }
}

struct BusResponse: Codable {
    let bus: [Bus]
}
