//
//  LoggedOutViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class LoggedOutViewController: UIViewController {

    @IBOutlet weak var logBackInButton: UIButton!
    
    override func viewDidLoad() {
        logBackInButton.layer.cornerRadius = logBackInButton.frame.height / 2
        UserController.shared.logOutUser { (success) in
            if success {
                print("👋👋👋 User logged out! Goodbye! 👋👋👋")
            }
        }
    }
    
    @IBAction func logBackInButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToLandingPage", sender: self)
    }
    
}
