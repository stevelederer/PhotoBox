//
//  CreateEventTableViewController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/22/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class CreateEventTableViewController: UITableViewController, UITextFieldDelegate {

     //   MARK: - Outlets
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var eventDetails: UITextView!
    @IBOutlet weak var createEvent: UIButton!
    var startTime: TimeInterval?
    var endTime: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        guard let eventName = eventName.text, eventName != "",
            let startTimeText = startTimeTextField.text,
            !startTimeText.isEmpty,
            let startTime = startTime,
            let endTimeText = endTimeTextField.text,
            !endTimeText.isEmpty,
            let endTime = endTime,
            let eventLocation = eventLocation.text, eventLocation != "",
            let eventDetails = eventDetails.text, eventDetails != "",
            let backgroundImage = backgroundImage.image
            else { return }
        
        EventController.shared.createAnEvent(eventName: eventName, creatorID: UserController.shared.currentUser!.uuid , memberIDs: [], startTime: startTime, endTime: endTime, details: eventDetails, location: eventLocation, coverPhoto: backgroundImage) { (event) in
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

}
