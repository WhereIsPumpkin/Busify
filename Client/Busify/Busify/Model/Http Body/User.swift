//
//  User.swift
//  iNet
//
//  Created by Saba Gogrichiani on 17.01.24.
//

import Foundation

struct User: Codable {
    var id: String
    var name: String
    var lastName: String
    var email: String
    var verified: Bool
    var bookmarkedStops: [String]
    var balance: Double
    var card: Card?
}

struct Card: Codable {
    var cardNumber: String?
    var cardName: String?
    var cardDate: String?
    var cardCVV: String?
}

public struct CardDetails {
    public var number: String?
    public var name: String?
    public var expiryDate: String?
}
