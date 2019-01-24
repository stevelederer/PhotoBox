//
//  ForgotPasswordViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/23/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLinkButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func emailLinkButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        if email.isEmpty {
            presentEmptyEmailAlert()
        } else {
            UserController.shared.forgotPassword(email: email) { (success) in
                if success {
                    self.passwordResetSuccessAlert()
                }
            }
        }
    }
    
    @IBAction func backToLoginButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func presentEmptyEmailAlert() {
        let emptyEmailAlert = UIAlertController(title: "Enter your email!", message: "Enter an email address and tap the button to reset password", preferredStyle: .alert)
        emptyEmailAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(emptyEmailAlert, animated: true)
    }
    
    func passwordResetSuccessAlert() {
        let passwordResetSuccessAlert = UIAlertController(title: "Sent!", message: "Password reset email has been sent.", preferredStyle: .alert)
        passwordResetSuccessAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(passwordResetSuccessAlert, animated: true)
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
