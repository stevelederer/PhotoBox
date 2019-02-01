//
//  ModalNotificationAuthViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 2/1/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit
import UserNotifications

class ModalNotificationAuthViewController: UIViewController {
    @IBOutlet weak var continueButon: UIButton!
    @IBOutlet weak var popUpView: UIView!
    
    let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButon.layer.cornerRadius = continueButon.frame.height / 2
        popUpView.layer.cornerRadius = 10
        popUpView.layer.shadowOpacity = 0.5
        popUpView.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        popUpView.layer.shadowRadius = 10
        popUpView.layer.cornerRadius = 10
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                self.center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                print("🥳🥳🥳🥳🥳 Notifications Authorized!")
            }
        }
    }
    
}
