//
//  EnterCodeViewController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/24/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class EnterCodeViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var enterCodeTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterCodeTextField.delegate = self
        enterCodeTextField.textAlignment = .center
        enterCodeTextField.layer.cornerRadius = enterCodeTextField.frame.height / 2
        enterCodeTextField.clipsToBounds = true
        enterCodeTextField.layer.borderWidth = 2
        enterCodeTextField.layer.borderColor = UIColor(named: "textDarkGray")?.cgColor
        continueButton.layer.cornerRadius = continueButton.frame.height / 2

    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = enterCodeTextField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 4
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
