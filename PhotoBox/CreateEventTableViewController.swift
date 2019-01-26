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

        

    }
    
    @IBAction func importBackgroundImage(_ sender: Any) {
        
        let backGroundimage = UIImagePickerController()
        backGroundimage.delegate = self
        backGroundimage.sourceType = UIImagePickerController.SourceType.photoLibrary
        backGroundimage.allowsEditing = true
        backGroundimage.setEditing(true, animated: true)
        self.present(backGroundimage, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            backgroundImage.image = image
        } else {
            print("Error picking image)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func startTime(_ sender: UITextField) {
        
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        sender.inputView = datePicker
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
        datePicker.addTarget(self, action: #selector(CreateEventTableViewController.endDatePickerValueChanged), for: UIControl.Event.valueChanged)
        
    }
    @objc func endDatePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        endTimeTextField.text = dateFormatter.string(from: sender.date)
        endTime = sender.date.timeIntervalSince1970
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
        
        EventController.shared.createAnEvent(eventName: eventName, creatorID: currentUser.uuid , memberIDs: [currentUser.uuid], startTime: startTime, endTime: endTime, details: eventDetails, location: eventLocation, coverPhoto: backgroundImage) { (event) in
            if let event = event {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let eventDetailVC = storyboard.instantiateViewController(withIdentifier: "eventDetailVC") as! EventDetailTableViewController
                
                eventDetailVC.event = event
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(eventDetailVC, animated: true)
                }
            }
        }
    }
    
    func presentRequiredFieldAlert() {
        let requiredFieldsAlert = UIAlertController(title: "OOPS!", message: "Event Name, Start Time, and End Time are required fields.", preferredStyle: .alert)
        requiredFieldsAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(requiredFieldsAlert, animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
