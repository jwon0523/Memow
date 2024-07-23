//
//  NotificationManager.swift
//  Memow
//
//  Created by jaewon Lee on 7/23/24.
//

import Foundation
import UserNotifications
import CoreLocation

class NotificationManager: ObservableObject {
    static let instance = NotificationManager()
    
    @Published var authorizationStatus: UNAuthorizationStatus?
    
    init() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
}

extension NotificationManager {
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("ERROR: \(error)")
                } else {
                    print("Permission granted: \(granted)")
                    self.authorizationStatus = granted ? .authorized : .denied
                }
            }
        }
    }
    
    func scheduleNotification(date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Scheduled Alert"
        content.subtitle = "This is your custom notification!"
        content.sound = .default
        content.badge = 1
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled for \(date)!")
            }
        }
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
