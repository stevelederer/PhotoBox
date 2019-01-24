//
//  SettingsViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/23/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var changePictureButton: UnderlineButtonTextPurple!
    @IBOutlet weak var changeDisplayNameButton: UnderlineButtonTextPurple!
    @IBOutlet weak var changeUsernameButton: UnderlineButtonTextPurple!
    @IBOutlet weak var deleteAccountButton: UnderlineButtonTextPurple!
    @IBOutlet weak var eventReminderNotificationSwitch: UISwitch!
    @IBOutlet weak var photosAddedNotificationSwitch: UISwitch!
    @IBOutlet weak var automaticUploadReminderNotificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationItem()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 5
        let navigationTitleFont = UIFont(name: "OpenSans-SemiBold", size: 20)
        let navigationTitleColor = UIColor(named: "textDarkGray")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: navigationTitleFont!, NSAttributedString.Key.foregroundColor: navigationTitleColor!]
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height / 2
        changePictureButton.setTitle("Change Picture", for: .normal)
        changeDisplayNameButton.setTitle("Change Display Name", for: .normal)
        changeUsernameButton.setTitle("Change Username", for: .normal)
        deleteAccountButton.setTitle("Delete Account", for: .normal)
        eventReminderNotificationSwitch.layer.borderColor = UIColor(named: "darkGrayText")?.cgColor
        eventReminderNotificationSwitch.layer.borderWidth = 2
        eventReminderNotificationSwitch.layer.cornerRadius = eventReminderNotificationSwitch.frame.height / 2
        photosAddedNotificationSwitch.layer.borderColor = UIColor(named: "darkGrayText")?.cgColor
        photosAddedNotificationSwitch.layer.borderWidth = 2
        photosAddedNotificationSwitch.layer.cornerRadius = photosAddedNotificationSwitch.frame.height / 2
        automaticUploadReminderNotificationSwitch.layer.borderColor = UIColor(named: "darkGrayText")?.cgColor
        automaticUploadReminderNotificationSwitch.layer.borderWidth = 2
        automaticUploadReminderNotificationSwitch.layer.cornerRadius = automaticUploadReminderNotificationSwitch.frame.height / 2
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
