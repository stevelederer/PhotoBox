//
//  NotificationManager.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/30/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static func scheduleEventNotification(for event: Event) {
        let content = UNMutableNotificationContent()
        content.title = "Upload time!"
        content.body = "It's time to upload to the PhotoBox for \(event.eventName)"
        content.sound = UNNotificationSound.default
        content.userInfo = ["eventID" : event.uuid]
        
        let eventEndDate = Date(timeIntervalSince1970: event.endTime)
        let components = Calendar.current.dateComponents([.month, .day, .year, .hour, .minute], from: eventEndDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "FirstEventEndReminder", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("📞📞📞📞 Notification scheduled for \(eventEndDate)")
            }
        }
        
    }
    
}
