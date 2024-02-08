//
//  BusStop.swift
//  iNet
//
//  Created by Saba Gogrichiani on 20.01.24.
//

import Foundation

struct Location: Codable {
    let id: String
    let code: String?
    let name: String
    let lat: Double
    let lon: Double

    enum CodingKeys: String, CodingKey {
        case id, code, name, lat, lon
    }
}

typealias Locations = [Location]
