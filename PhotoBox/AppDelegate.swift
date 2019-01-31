//
//  AppDelegate.swift
//  BatchShare
//
//  Created by Cameron Milliken on 1/15/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit
import Firebase
//import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .badge, .sound])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        if response.notification.request.identifier == "FirstEventEndReminder" {
//            print("handling the firstEventReminder notification")
//            DispatchQueue.main.async {
//                self.notificationAction1()
//            }
//        }
//        completionHandler()
//
//    }
//
//    func notificationAction1() {
//        redirectToVC()
//    }
//
//    func redirectToVC() {
//        let signInStoryboard: UIStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
//
//        let toVC = EventDetailTableViewController()
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
//        UNUserNotificationCenter.current().delegate = self
        
        // TEST SAVING A SINGLE PHOTO
        
        /*
        let image = #imageLiteral(resourceName: "PhotoBoxLoadingScreen")
        let newPhoto = Photo(image: image, eventID: "", creatorID: "")
        FirebaseManager.uploadPhotoToFirebase(newPhoto) { (url, error) in
            if let error = error {
                print("❌\(error.localizedDescription)")
            }
            if let url = url {
                print("\(url)")
            }
        }
         */

        // TEST SAVING AN ARRAY OF PHOTOS
        
        /*
        PhotoController.shared.upload(images: [UIImage(named: "Lederer_Volt_Corner")!, UIImage(named: "Lederer_Volt_Driver")!, UIImage(named: "Lederer_Volt_Front")!, UIImage(named: "Lederer_Volt_Passenger")!, UIImage(named: "Lederer_Volt_Rear")!], for: "eventeventeventevent", from: "stevestevesteve") { (success) in
            if success {
                print("Success uploading photos!")
            } else {
                print("Error uploading photos!")
            }
        }
         */
        
        //Test fetching an event with criteria
//        FirebaseManager.fetchFirestoreWithFieldAndCriteria(for: "eventCode", criteria: "KKYL", inArray: false) { (events: [Event]?) in
//            if let events = events {
//                print("✅Event Found! Event Name is \(String(describing: events.first?.eventName))")
//            } else {
//                print("❌No event found for that code")
//            }
//        }
        return true
    }
}
