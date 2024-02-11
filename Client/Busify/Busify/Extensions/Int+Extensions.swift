//
//  Int+Extensions.swift
//  iNet
//
//  Created by Saba Gogrichiani on 30.01.24.
//

import Foundation

extension Int {
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
