//
//  Passengers.swift
//  iNet
//
//  Created by Saba Gogrichiani on 30.01.24.
//

import Foundation

struct TransactionsResponse: Decodable {
    let transactionsByTransportTypes: TransportTypes

    enum CodingKeys: String, CodingKey {
        case transactionsByTransportTypes = "transactionsByTransportTypes"
    }
}

struct TransportTypes: Decodable {
    let cableCar: Int
    let subway: Int
    let bus: Int
    let minibus: Int

    enum CodingKeys: String, CodingKey {
        case cableCar = "საბაგირო"
        case subway = "მეტრო"
        case bus = "თბილისის ავტობუსი"
        case minibus = "თბილისი მიკროავტობუსი"
    }
}

