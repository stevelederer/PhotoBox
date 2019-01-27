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
    
    var selectedEventID: String? {
        didSet {
            guard let selectedEventID = selectedEventID else { return }
            FirebaseManager.fetchFromFirestore(uuid: selectedEventID) { (T: Event?) in
                if let event = T {
                    self.selectedEvent = event
                }
            }
        }
    }
    var selectedEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterCodeTextField.delegate = self
        enterCodeTextField.textAlignment = .center
        enterCodeTextField.layer.cornerRadius = enterCodeTextField.frame.height / 2
        enterCodeTextField.clipsToBounds = true
        enterCodeTextField.layer.borderWidth = 3
        enterCodeTextField.layer.borderColor = UIColor(named: "textDarkGray")?.cgColor
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        guard let currentUser = UserController.shared.currentUser else { return }
        guard let enteredCode = enterCodeTextField.text, enterCodeTextField.text?.count == 4 else { presentRequiredFieldAlert() ; return }
        FirebaseManager.fetchFirestoreWithFieldAndCriteria(for: "eventCode", criteria: enteredCode, inArray: false) { (events: [Event]?) in
            guard let events = events else { print("❌❌❌❌ no event found for that code") ; return }
            guard let uuid = events.first?.uuid else { return }
            if let eventName = events.first?.eventName {
                print("Joining event: \(eventName)")
            }
            currentUser.eventIDs?.append(uuid)
            UserController.shared.changeUserInfo(user: currentUser, completion: { (success) in
                if !success {
                    print("error saving new eventID to currentUser in database")
                }
            })
            self.selectedEventID = uuid
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let eventDetailVC = storyboard.instantiateViewController(withIdentifier: "eventDetailVC") as! EventDetailTableViewController
            
            guard let selectedEvent = self.selectedEvent else { return }
            eventDetailVC.event = selectedEvent
            eventDetailVC.currentUser = currentUser
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(eventDetailVC, animated: true)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = enterCodeTextField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 4
    }
    
    func presentRequiredFieldAlert() {
        let requiredFieldAlert = UIAlertController(title: "Required Field", message: "Please enter a code consisting of 4 alphanumeric characters", preferredStyle: .alert)
        requiredFieldAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(requiredFieldAlert, animated: true)
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
