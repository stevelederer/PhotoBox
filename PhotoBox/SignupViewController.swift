//
//  SignupViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var termsAndConditionsButton: UnderlineButtonText!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var acceptedTermsAndContitions = false
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let darkGrayBorder: UIColor = UIColor(displayP3Red: 0.59, green: 0.59, blue: 0.59, alpha: 1)
        nameTextField.layer.borderWidth = 3
        nameTextField.layer.borderColor = darkGrayBorder.cgColor
        nameTextField.layer.cornerRadius = 5
        emailTextField.layer.borderWidth = 3
        emailTextField.layer.borderColor = darkGrayBorder.cgColor
        emailTextField.layer.cornerRadius = 5
        usernameTextField.layer.borderWidth = 3
        usernameTextField.layer.borderColor = darkGrayBorder.cgColor
        usernameTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderWidth = 3
        passwordTextField.layer.borderColor = darkGrayBorder.cgColor
        passwordTextField.layer.cornerRadius = 5
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        signUpButton.backgroundColor = UIColor(red: 0.43, green: 0.44, blue: 0.78, alpha: 1)
        checkBoxButton.layer.borderWidth = 2
        checkBoxButton.layer.borderColor = darkGrayBorder.cgColor
        checkBoxButton.layer.cornerRadius = 5
        termsAndConditionsButton.setTitle("Terms and conditions", for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text,
            !name.isEmpty,
        let email = emailTextField.text,
        !email.isEmpty,
        let username = usernameTextField.text,
        !username.isEmpty,
        let password = usernameTextField.text,
            !password.isEmpty else { presentRequiredFieldAlert() ; return }
        
        if acceptedTermsAndContitions {
            UserController.shared.signUpUser(name: name, email: email, username: username, password: password) { (success, error) in
                if let error = error {
                    self.presentSignUpErrorAlert(error: error)
                } else {
                    self.performSegue(withIdentifier: "signUpSuccess", sender: self)
                }
            }
        } else {
            presentTermsAndConditionsAlert()
        }
    }
    
    @IBAction func checkBoxButtonTapped(_ sender: UIButton) {
        if acceptedTermsAndContitions == false {
            checkBoxButton.setTitle("✔", for: .normal)
            acceptedTermsAndContitions = true
        } else {
            checkBoxButton.setTitle("", for: .normal)
            acceptedTermsAndContitions = false
        }
    }
    
    func presentRequiredFieldAlert() {
        let requiredFieldAlert = UIAlertController(title: "Missing Information!", message: "All fields are required.", preferredStyle: .alert)
        requiredFieldAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(requiredFieldAlert, animated: true)
    }
    
    func presentSignUpErrorAlert(error: Error) {
        let signUpErrorAlert = UIAlertController(title: "Error!", message: "\(error.localizedDescription)", preferredStyle: .alert)
        signUpErrorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(signUpErrorAlert, animated: true)
    }
    
    func presentTermsAndConditionsAlert() {
        let termsAndContitionsAlert = UIAlertController(title: "Terms and Conditions", message: "Please read and accept terms and conditions before continuing.", preferredStyle: .alert)
        termsAndContitionsAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(termsAndContitionsAlert, animated: true)
    }
}
