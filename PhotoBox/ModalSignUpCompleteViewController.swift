//
//  ModalSignUpCompleteViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/31/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class ModalSignUpCompleteViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var letsGoButton: UIButton!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        letsGoButton.layer.cornerRadius = letsGoButton.frame.height / 2
        popUpView.layer.cornerRadius = 10
        popUpView.layer.shadowOpacity = 0.5
        popUpView.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        popUpView.layer.shadowRadius = 10
        popUpView.layer.cornerRadius = 10
    }
    
    // MARK: - Actions
    
    @IBAction func letsGoButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .letsGoButtonTapped, object: nil)
        }
    }
    
}
