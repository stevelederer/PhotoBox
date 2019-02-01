//
//  ModalEmailSentViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/31/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class ModalEmailSentViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        popUpView.layer.cornerRadius = 10
        popUpView.layer.shadowOpacity = 0.5
        popUpView.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        popUpView.layer.shadowRadius = 10
        popUpView.layer.cornerRadius = 10
    }
    
    // MARK: - Actions
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
