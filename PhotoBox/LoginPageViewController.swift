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
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UnderlineButtonText!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let darkGrayBorder: UIColor = UIColor(displayP3Red: 0.59, green: 0.59, blue: 0.59, alpha: 1)
        emailTextField.layer.borderWidth = 3
        emailTextField.layer.borderColor = darkGrayBorder.cgColor
        emailTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderWidth = 3
        passwordTextField.layer.borderColor = darkGrayBorder.cgColor
        passwordTextField.layer.cornerRadius = 5
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.backgroundColor = UIColor(displayP3Red: 0.61, green: 0.61, blue: 0.61, alpha: 1)
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        signUpButton.backgroundColor = UIColor(displayP3Red: 0.61, green: 0.61, blue: 0.61, alpha: 1)
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
