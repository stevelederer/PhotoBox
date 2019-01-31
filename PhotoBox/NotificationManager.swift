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
        content.title = ""
        
        let eventEndDate = Date(timeIntervalSince1970: event.endTime)
        let components = Calendar.current.dateComponents([.month, .day, .year, .hour, .minute], from: eventEndDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
    }
    
}
