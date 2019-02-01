//
//  ForgotPasswordViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/23/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: PaddingTextField!
    @IBOutlet weak var emailLinkButton: UIButton!
    @IBOutlet weak var backToLoginButton: UnderlineButtonTextLightGray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundImage = UIImage(named: "PhotoBoxBackgroundLight") {
            self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        guard let darkGrayBorder: UIColor = UIColor(named: "textDarkGray") else { return }
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
        emailTextField.clipsToBounds = true
        emailTextField.layer.borderWidth = 3
        emailTextField.layer.borderColor = darkGrayBorder.cgColor
        emailLinkButton.layer.cornerRadius = emailLinkButton.frame.height / 2
        backToLoginButton.setTitle("Back to Login", for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func emailLinkButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        if email.isEmpty {
            self.presentPhotoBoxModalVC(message: "Wait! We need your email so we can send out the reset link!")
        } else {
            UserController.shared.forgotPassword(email: email) { (success) in
                if success {
                    self.presentModalEmailSent()
                }
            }
        }
    }
    
    @IBAction func backToLoginButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            self.emailLinkButtonTapped(emailLinkButton)
        }
        return true
    }
    
}
