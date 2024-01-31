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
}
