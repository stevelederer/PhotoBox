//
//  SignupViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var termsAndConditionsButton: UnderlineButtonText!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
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
        signUpButton.backgroundColor = UIColor(displayP3Red: 0.61, green: 0.61, blue: 0.61, alpha: 1)
        checkBoxButton.layer.borderWidth = 2
        checkBoxButton.layer.borderColor = darkGrayBorder.cgColor
        checkBoxButton.layer.cornerRadius = 5
        checkBoxButton.setTitle("", for: .normal)
        checkBoxButton.setTitle("✔", for: .selected)
        checkBoxButton.isSelected = false
        termsAndConditionsButton.setTitle("Terms and conditions", for: .normal)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text,
            !name.isEmpty,
        let email = emailTextField.text,
        !email.isEmpty,
        let username = usernameTextField.text,
        !username.isEmpty,
        let password = usernameTextField.text,
            !password.isEmpty else { presentRequiredFieldAlert() ; return }
        
        if checkBoxButton.isSelected {
            UserController.shared.signUpUser(name: name, email: email, username: username, password: password) { (_) in
                #warning("check for sign up, and sign in new user")
            }
        } else {
            presentTermsAndConditionsAlert()
        }
    }
    
    @IBAction func checkBoxButtonTapped(_ sender: UIButton) {
        if checkBoxButton.isSelected == false {
            checkBoxButton.isSelected = true
        } else {
            checkBoxButton.isSelected = false
        }
    }
    
    func presentRequiredFieldAlert() {
        
    }
    
    func presentTermsAndConditionsAlert() {
        
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
