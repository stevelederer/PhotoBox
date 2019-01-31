//
//  LoginPageViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {

    @IBOutlet weak var emailTextField: PaddingTextField!
    @IBOutlet weak var passwordTextField: PaddingTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UnderlineButtonTextDarkGray!
    @IBOutlet weak var forgotPasswordButton: UnderlineButtonTextLightGray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let darkGrayBorder: UIColor = UIColor(named: "textDarkGray") else { return }
        emailTextField.layer.borderWidth = 3
        emailTextField.layer.borderColor = darkGrayBorder.cgColor
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
        passwordTextField.layer.borderWidth = 3
        passwordTextField.layer.borderColor = darkGrayBorder.cgColor
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 2
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        signUpButton.setTitle("SIGN UP", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text,
        !email.isEmpty,
        let password = passwordTextField.text,
            !password.isEmpty else { self.presentPhotoBoxModalVC(message: "Oops! Looks like all fields are required!") ; return }
        
        UserController.shared.logInUser(email: email, password: password) { (success, error) in
            if let error = error {
                self.presentLogInErrorAlert(error: error)
            } else {
                self.performSegue(withIdentifier: "logInSuccess", sender: self)
            }
        }
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
    }
    
//    func presentRequiredFieldAlert() {
//        let requiredFieldAlert = UIAlertController(title: "Missing Information!", message: "Please enter a username and password.", preferredStyle: .alert)
//        requiredFieldAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
//        self.present(requiredFieldAlert, animated: true)
//    }
    
    func presentLogInErrorAlert(error: Error) {
        let logInErrorAlert = UIAlertController(title: "Error!", message: "\(error.localizedDescription)", preferredStyle: .alert)
        logInErrorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(logInErrorAlert, animated: true)
    }
    
    // MARK: - TextFieldDelegate Methods
    
}

extension LoginPageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.logInButtonTapped(loginButton)
        }
        return true
    }
    
}
