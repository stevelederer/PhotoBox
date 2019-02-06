//
//  EnterCodeViewController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/24/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class EnterCodeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var enterCodeTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationItem()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 5
        let navigationTitleFont = UIFont(name: "OpenSans-SemiBold", size: 20)
        let navigationTitleColor = UIColor(named: "textDarkGray")
        self.navigationItem.title = "Join PhotoBox"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: navigationTitleFont!, NSAttributedString.Key.foregroundColor: navigationTitleColor!]
        enterCodeTextField.delegate = self
        enterCodeTextField.textAlignment = .center
        enterCodeTextField.layer.cornerRadius = enterCodeTextField.frame.height / 2
        enterCodeTextField.clipsToBounds = true
        enterCodeTextField.layer.borderWidth = 3
        enterCodeTextField.layer.borderColor = UIColor(named: "textDarkGray")?.cgColor
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        enterCodeTextField.text = nil
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        guard let enteredCode = enterCodeTextField.text?.uppercased(), enterCodeTextField.text?.count == 4 else { presentRequiredFieldAlert() ; return }
        FirebaseManager.fetchFirestoreWithFieldAndCriteria(for: "eventCode", criteria: enteredCode, inArray: false) { (events: [Event]?) in
            guard let events = events else { print("❌❌❌❌ no event found for that code") ; return }
            guard let event = events.first else { return }
            let eventName = event.eventName
            print("Joining event: \(eventName)")
            if UserController.shared.currentUser?.eventIDs == nil {
                UserController.shared.currentUser?.eventIDs = [event.uuid]
            } else {
                UserController.shared.currentUser?.eventIDs?.append(event.uuid)
            }
            guard let currentUser = UserController.shared.currentUser else { print("❌❌❌❌ no current user found") ; return }
            UserController.shared.changeUserInfo(user: currentUser, completion: { (success) in
                if !success {
                    print("❌❌❌❌ error saving new eventID to currentUser in database")
                } else {
                    print("✅✅✅✅ User eventIDs updated in database")
                }
            })
            event.memberIDs.append(currentUser.uuid)
            EventController.shared.updateAnEvent(event: event, eventName: event.eventName, memberIDs: event.memberIDs, startTime: event.startTime, endTime: event.endTime, details: event.details, location: event.location, completion: { (success) in
                if success {
                    print("✅✅✅✅ Success updating event info!")
                } else {
                    print("❌❌❌❌ error updating event in database")
                }
            })
            self.transitionToDetailView(user: currentUser, event: event)
        }
    }
    
    func transitionToDetailView(user: AppUser, event: Event) {
        let selectedEvent = event
        
        if let eventDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "eventDetailVC") as? EventDetailTableViewController {
            eventDetailVC.event = selectedEvent
            self.navigationController?.pushViewController(eventDetailVC, animated: true)
        }
    }
    
    //   MARK: - Textfield Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = enterCodeTextField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 4
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == enterCodeTextField {
            self.continueButtonTapped(continueButton)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == enterCodeTextField {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: {self.view.frame.origin.y = -100},
                           completion: nil)
        }
    }
    
    
    
    func presentRequiredFieldAlert() {
        self.presentPhotoBoxModalVC(message: "Oops! We need the code to get you connected!")
    }
}
