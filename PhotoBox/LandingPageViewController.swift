//
//  LandingPageViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/22/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UserController.shared.checkForLoggedInUser { (success) in
            if success {
                self.performSegue(withIdentifier: "userIsLoggedIn", sender: self)
            } else {
                
                self.performSegue(withIdentifier: "toWelcomePageVC", sender: self)
            }
        }
    }
    
    
    // have to unwind to landing page instead of login page, because when the app successfully checks for a logged in user, it never instantiates the login screen, so there is no possibility of unwinding to login screen without moving the responsibility for the check for logged in user to the login screen view controller
    @IBAction func unwindToLoginPage(segue:UIStoryboardSegue) {
    }
}
