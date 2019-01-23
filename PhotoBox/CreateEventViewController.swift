//
//  CreateEventViewController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/22/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

   
    @IBOutlet weak var backgroundPhoto: UIImageView!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var eventDetails: UITextView!
    @IBOutlet weak var inviteConnections: UIButton!
    @IBOutlet weak var createEvent: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func inviteConnectionsButtonTapped(_ sender: Any) {
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
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
