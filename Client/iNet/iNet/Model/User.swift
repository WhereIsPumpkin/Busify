//
//  User.swift
//  iNet
//
//  Created by Saba Gogrichiani on 17.01.24.
//

import Foundation

struct User: Codable {
    var name: String
    var lastName: String
    var email: String
    var password: String
    var gender: Gender
}

enum Gender: String, CaseIterable, Codable {
    case female = "Female"
    case male = "Male"
}
