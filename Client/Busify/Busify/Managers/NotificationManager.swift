//
//  NotificationManager.swift
//  iNet
//
//  Created by Saba Gogrichiani on 26.01.24.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {}
    
    func checkForPermission() {
        notificationCenter.getNotificationSettings { setting in
            switch setting.authorizationStatus {
            case .notDetermined:
                self.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        print("Granted")
                    }
                }
            case .denied:
                break
            case .authorized, .provisional, .ephemeral:
                break
            @unknown default:
                print("Unknown authorization status")
            }
        }
    }
    
    func dispatchNotification(identifier: String, title: String, body: String, hour: Int, minute: Int, isDaily: Bool) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
}

