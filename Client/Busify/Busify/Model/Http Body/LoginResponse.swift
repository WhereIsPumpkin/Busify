//
//  LoginResponse.swift
//  iNet
//
//  Created by Saba Gogrichiani on 31.01.24.
//

import Foundation

struct LoginResponse: Codable {
    let token: String
    let user: User
}
