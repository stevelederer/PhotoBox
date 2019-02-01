


//
//  SignupViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var nameTextField: PaddingTextField!
    @IBOutlet weak var emailTextField: PaddingTextField!
    @IBOutlet weak var usernameTextField: PaddingTextField!
    @IBOutlet weak var passwordTextField: PaddingTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UnderlineButtonTextDarkGray!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundImage = UIImage(named: "PhotoBoxBackgroundLight") {
            self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        let darkGrayBorder: UIColor = UIColor(displayP3Red: 0.59, green: 0.59, blue: 0.59, alpha: 1)
        nameTextField.layer.borderWidth = 3
        nameTextField.layer.borderColor = darkGrayBorder.cgColor
        nameTextField.layer.cornerRadius = nameTextField.frame.height / 2
        emailTextField.layer.borderWidth = 3
        emailTextField.layer.borderColor = darkGrayBorder.cgColor
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
        usernameTextField.layer.borderWidth = 3
        usernameTextField.layer.borderColor = darkGrayBorder.cgColor
        usernameTextField.layer.cornerRadius = usernameTextField.frame.height / 2
        passwordTextField.layer.borderWidth = 3
        passwordTextField.layer.borderColor = darkGrayBorder.cgColor
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 2
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        signUpButton.backgroundColor = UIColor(red: 0.43, green: 0.44, blue: 0.78, alpha: 1)
        logInButton.setTitle("LOG IN", for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(signUpSuccess), name: .letsGoButtonTapped, object: nil)
    }
    
    //   MARK: - TextfieldDelegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextField {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: { self.view.frame.origin.y = -100 },
                           completion: nil)
        }
        if textField == usernameTextField {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: { self.view.frame.origin.y = -150 },
                           completion: nil)
        }
        if textField == emailTextField {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: { self.view.frame.origin.y = -175 },
                           completion: nil)
        } else if textField == passwordTextField {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: { self.view.frame.origin.y = -205 },
                           completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.view.frame.origin.y = 0
            }, completion: nil)
        }
        return true
    }
    
    // MARK: - Actions
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text,
            !name.isEmpty,
            let email = emailTextField.text,
            !email.isEmpty,
            let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else { presentRequiredFieldAlert() ; return }
        
        UserController.shared.signUpUser(name: name, email: email, username: username, password: password) { (success, error) in
            if let error = error {
                self.presentSignUpErrorAlert(error: error)
            } else {
                self.presentModalCompletedSignUp()
            }
        }
        
    }
    
    @objc func signUpSuccess() {
        self.performSegue(withIdentifier: "signUpSuccess", sender: self)
    }
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
    
}

