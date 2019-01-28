//
//  CreateEventTableViewController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/22/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class CreateEventTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

     //   MARK: - Outlets
    @IBOutlet weak var selectCoverPhotoButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var eventLocationTextField: UITextField!
    @IBOutlet weak var eventDetailsTextView: UITextView!
    @IBOutlet weak var createEventButton: UIButton!
    var startTime: TimeInterval?
    var endTime: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let borderColor = UIColor(named: "textDarkGray")?.cgColor
        eventNameTextField.layer.cornerRadius = eventNameTextField.frame.height / 2
        eventNameTextField.layer.borderWidth = 2
        eventNameTextField.layer.borderColor = borderColor
        eventNameTextField.clipsToBounds = true
        
        startTimeTextField.layer.cornerRadius = startTimeTextField.frame.height / 2
        startTimeTextField.layer.borderWidth = 2
        startTimeTextField.layer.borderColor = borderColor
        startTimeTextField.clipsToBounds = true

        endTimeTextField.layer.cornerRadius = endTimeTextField.frame.height / 2
        endTimeTextField.layer.borderWidth = 2
        endTimeTextField.layer.borderColor = borderColor
        endTimeTextField.clipsToBounds = true

        eventLocationTextField.layer.cornerRadius = eventLocationTextField.frame.height / 2
        eventLocationTextField.layer.borderWidth = 2
        eventLocationTextField.layer.borderColor = borderColor
        eventLocationTextField.clipsToBounds = true

        eventDetailsTextView.layer.cornerRadius = 9
        eventDetailsTextView.layer.borderWidth = 2
        eventDetailsTextView.layer.borderColor = borderColor
        eventDetailsTextView.clipsToBounds = true
        
        createEventButton.layer.cornerRadius = createEventButton.frame.height / 2
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "buttonPurple")

//        // Listen for keyboard events
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
 
//    deinit {
//        // stop listening for keyboard hide/show events
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
    
//    @objc func keyboardWillShow(_ notification: Notification) {
//        let userInfo = notification.userInfo ?? [:]
//        let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        let height = keyboardFrame.height + 20
//        tableView.keyboardRaised(height: height)
//    }
//
//    @objc func keyboardWillHide(_ notification: Notification) {
//        tableView.keyboardClosed()
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case eventNameTextField:
            startTimeTextField.becomeFirstResponder()
        case startTimeTextField:
            endTimeTextField.becomeFirstResponder()
        case endTimeTextField:
            eventLocationTextField.becomeFirstResponder()
        case eventLocationTextField:
            eventDetailsTextView.becomeFirstResponder()
        default:
            eventDetailsTextView.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func selectCoverPhotoButtonTapped(_ sender: Any) {
        
        let backgroundimage = UIImagePickerController()
        backgroundimage.delegate = self
        backgroundimage.sourceType = UIImagePickerController.SourceType.photoLibrary
        backgroundimage.allowsEditing = true
        backgroundimage.setEditing(true, animated: true)
        self.present(backgroundimage, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.backgroundImage.image = image
            selectCoverPhotoButton.isHidden = true
        } else if let image = info[.originalImage] as? UIImage {
            backgroundImage.image = image
            selectCoverPhotoButton.isHidden = true
        } else {
            print("Error picking image)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startTime(_ sender: UITextField) {
        
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        sender.inputView = datePicker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.done, target: self, action: #selector(startTimePickerNextButtonPressed))
        toolBar.setItems([space, nextButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        sender.inputAccessoryView = toolBar
        
        datePicker.addTarget(self, action: #selector(CreateEventTableViewController.startDatePickerValueChanged), for: UIControl.Event.valueChanged)
    }

    
    @objc func startDatePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        startTimeTextField.text = dateFormatter.string(from: sender.date)
        startTime = sender.date.timeIntervalSince1970
    }
    
    @IBAction func endTime(_ sender: UITextField) {
        
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        sender.inputView = datePicker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.done, target: self, action: #selector(endTimePickerNextButtonPressed))
        toolBar.setItems([space, nextButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        sender.inputAccessoryView = toolBar
        
        datePicker.addTarget(self, action: #selector(CreateEventTableViewController.endDatePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func endDatePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        endTimeTextField.text = dateFormatter.string(from: sender.date)
        endTime = sender.date.timeIntervalSince1970
    }
    
    
    @objc func startTimePickerNextButtonPressed() {
        endTimeTextField.becomeFirstResponder()
    }
    
    @objc func endTimePickerNextButtonPressed() {
        eventLocationTextField.becomeFirstResponder()
    }
    
    @IBAction func createEventButtonTapped(_ sender: Any) {
        guard let eventName = eventNameTextField.text,
            !eventName.isEmpty,
            let currentUser = UserController.shared.currentUser,
            let startTime = startTime,
            startTimeTextField.text != "",
            let endTime = endTime,
            endTimeTextField.text != "",
            let eventLocation = eventLocationTextField.text,
            let eventDetails = eventDetailsTextView.text,
            let backgroundImage = backgroundImage.image
            else { presentRequiredFieldAlert() ; return }
        
        
        
        EventController.shared.createAnEvent(eventName: eventName, creatorID: currentUser.uuid , memberIDs: [currentUser.uuid], startTime: startTime, endTime: endTime, details: eventDetails, location: eventLocation) { (event) in
            if let event = event {
                let backgroundPhoto = Photo(image: backgroundImage, eventID: event.uuid, creatorID: currentUser.uuid)
                event.coverPhoto = backgroundImage
                FirebaseManager.uploadPhotoToFirebase(backgroundPhoto, completion: { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    if let url = url {
                        event.coverPhotoURL = "\(url)"
                        FirebaseManager.updateData(obect: event, dictionary: event.dictionary as [String : Any], completion: { (error) in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                print("success adding coverPhotoURL to new event.")
                            }
                        })
                    }
                })
                currentUser.eventIDs?.append(event.uuid)
                UserController.shared.changeUserInfo(user: currentUser, completion: { (success) in
                    if success {
                        print("success adding new event to the user's events array")
                    } else {
                        print("error adding new event to the user's events array")
                    }
                })
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let eventDetailVC = storyboard.instantiateViewController(withIdentifier: "eventDetailVC") as! EventDetailTableViewController
                
                eventDetailVC.event = event
                eventDetailVC.currentUser = currentUser
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(eventDetailVC, animated: true)
                }
            }
        }
    }
    
    func presentRequiredFieldAlert() {
        let requiredFieldsAlert = UIAlertController(title: "OOPS!", message: "Cover Photo, Event Name, Start Time, and End Time are required fields.", preferredStyle: .alert)
        requiredFieldsAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(requiredFieldsAlert, animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
