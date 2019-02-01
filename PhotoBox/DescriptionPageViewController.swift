//
//  DescriptionPageViewController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/25/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class DescriptionPageViewController: UIViewController {

    @IBOutlet weak var secondDisplayView: UIView!
    @IBOutlet weak var letsGoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondDisplayView.layer.shadowOpacity = 0.5
        secondDisplayView.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        secondDisplayView.layer.shadowRadius = 10
        secondDisplayView.layer.cornerRadius = 10
        letsGoButton.layer.cornerRadius = letsGoButton.frame.height / 2
    }
    
    @IBAction func letsGoButtonTappped(_ sender: Any) {
        self.performSegue(withIdentifier: "noUserLoggedIn", sender: self)
    }
}
