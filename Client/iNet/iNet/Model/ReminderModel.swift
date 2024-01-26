//
//  ReminderModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 26.01.24.
//

import Foundation

class Reminder {
    enum AlertType {
        case quick(minutes: Int)
        case specificDate(date: Date, isAllDay: Bool)
    }

    var alertType: AlertType

    init(alertType: AlertType) {
        self.alertType = alertType
    }

    func setAlertType(_ alertType: AlertType) {
        self.alertType = alertType
    }
}
