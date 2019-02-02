//
//  AppDelegate.swift
//  BatchShare
//
//  Created by Steve Lederer on 1/15/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("foo")
        if response.notification.request.identifier == "FirstEventEndReminder" {
            let payload = response.notification.request.content.userInfo
            let eventID = payload["eventID"] as? String
            
            guard let landingVC = UIStoryboard(name: "SignIn", bundle: nil).instantiateInitialViewController() as? LandingPageViewController else { return }
            landingVC.fromNotification = true
            landingVC.eventIDFromNotification = eventID
            window?.rootViewController = landingVC
            window?.makeKeyAndVisible()
            
            completionHandler()
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}
