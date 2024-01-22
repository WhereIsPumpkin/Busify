//
//  Message.swift
//  iNet
//
//  Created by Saba Gogrichiani on 22.01.24.
//

import Foundation

struct Message: Identifiable, Encodable {
    var id = UUID()
    let userType: UserType
    let text: String
}

enum UserType: Encodable {
    case user
    case system
}
