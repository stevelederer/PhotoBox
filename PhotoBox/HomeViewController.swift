//
//  HomeViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/22/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var createEventButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createEventButton.layer.cornerRadius = createEventButton.frame.height / 2
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        UserController.shared.logOutUser { (success) in
            if success {
                self.performSegue(withIdentifier: "logOutUser", sender: self)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
