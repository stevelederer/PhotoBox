//
//  WelcomePageViewController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/25/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIViewController {
    
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        displayView.layer.shadowOpacity = 0.5
        displayView.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        displayView.layer.shadowRadius = 10
        displayView.layer.cornerRadius = 10
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        segue()
        animate()
    }
    
    func segue() {
        self.performSegue(withIdentifier: "toDescriptionView", sender: self)
    }
    
    func animate() {
        UIView.animate(withDuration: 0.1, delay: 0.5, options: [.curveLinear], animations: {
            self.displayView.alpha = 0
        }, completion: nil)
    }
    
}
