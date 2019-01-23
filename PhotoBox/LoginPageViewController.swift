//
//  LoginPageViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UnderlineButtonText!
    @IBOutlet weak var forgotPasswordButton: UnderlineButtonText!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let darkGrayBorder: UIColor = UIColor(displayP3Red: 0.59, green: 0.59, blue: 0.59, alpha: 1)
        emailTextField.layer.borderWidth = 3
        emailTextField.layer.borderColor = darkGrayBorder.cgColor
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
        passwordTextField.layer.borderWidth = 3
        passwordTextField.layer.borderColor = darkGrayBorder.cgColor
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 2
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.backgroundColor = UIColor(red:0.43, green:0.44, blue:0.78, alpha:1)
        loginButton.setTitleColor(.white, for: .normal)
        signUpButton.setTitle("SIGN UP", for: .normal)

    }
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text,
        !email.isEmpty,
        let password = passwordTextField.text,
            !password.isEmpty else { presentRequiredFieldAlert() ; return }
        
        UserController.shared.logInUser(email: email, password: password) { (success, error) in
            if let error = error {
                self.presentLogInErrorAlert(error: error)
            } else {
                self.performSegue(withIdentifier: "logInSuccess", sender: self)
            }
        }
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        if email.isEmpty {
            presentForgotPasswordAlert()
        } else {
            UserController.shared.forgotPassword(email: email) { (success) in
                if success {
                    self.presentForgotPasswordSuccessAlert()
                }
            }
        }
    }
    
    func presentRequiredFieldAlert() {
        let requiredFieldAlert = UIAlertController(title: "Missing Information!", message: "Please enter a username and password.", preferredStyle: .alert)
        requiredFieldAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(requiredFieldAlert, animated: true)
    }
    
    func presentLogInErrorAlert(error: Error) {
        let logInErrorAlert = UIAlertController(title: "Error!", message: "\(error.localizedDescription)", preferredStyle: .alert)
        logInErrorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(logInErrorAlert, animated: true)
    }
    
    func presentForgotPasswordAlert() {
        #warning("add forgot password alert")
    }
    
    func presentForgotPasswordSuccessAlert() {
        #warning("add successful password reset alert")
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
