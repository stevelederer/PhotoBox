//
//  NewEventViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController {
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventTimeDateTextField: UITextField!
    @IBOutlet weak var eventLocationTextField: UITextField!
    @IBOutlet weak var eventDetailsTextView: UITextView!
    @IBOutlet weak var groupsTextField: UITextField!
    @IBOutlet weak var friendsTextField: UITextField!
    @IBOutlet weak var createEventButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        createEventButton.layer.cornerRadius = createEventButton.frame.height / 2
        createEventButton.backgroundColor = UIColor(displayP3Red: 0.61, green: 0.61, blue: 0.61, alpha: 1)
        
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
