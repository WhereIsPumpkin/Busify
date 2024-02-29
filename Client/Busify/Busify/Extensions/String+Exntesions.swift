//
//  String+Exntesions.swift
//  iNet
//
//  Created by Saba Gogrichiani on 27.01.24.
//

import Foundation

extension String {
    func toMinutes() -> Int {
        let components = self.components(separatedBy: " ")
        guard components.count >= 4 else { return 0 }
        let hours = Int(components[0]) ?? 0
        let minutes = Int(components[2]) ?? 0
        return hours * 60 + minutes
    }
}
