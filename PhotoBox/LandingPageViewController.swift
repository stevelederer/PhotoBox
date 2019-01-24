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
        if let backgroundImage = UIImage(named: "PhotoBoxLoadingScreen") {
            self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UserController.shared.checkForLoggedInUser { (success) in
            if success {
                self.performSegue(withIdentifier: "userIsLoggedIn", sender: self)
            } else {
                self.performSegue(withIdentifier: "noUserLoggedIn", sender: self)
            }
        }
    }
}
