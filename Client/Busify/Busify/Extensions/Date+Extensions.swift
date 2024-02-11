//
//  Date+Extensions.swift
//  iNet
//
//  Created by Saba Gogrichiani on 27.01.24.
//

import Foundation

extension Date {
    func adding(minutes: Int) -> (hour: Int, minute: Int) {
        let futureDate = Calendar.current.date(byAdding: .minute, value: minutes, to: self) ?? self
        let hour = Calendar.current.component(.hour, from: futureDate)
        let minute = Calendar.current.component(.minute, from: futureDate)
        return (hour, minute)
    }
}
