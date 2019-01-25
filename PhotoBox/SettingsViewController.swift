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
    
    var photo: UIImage = UIImage() {
        didSet {
            self.profilePicImageView.image = photo
        }
    }
    
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
    
    @IBAction func changePictureButtonTapped(_ sender: UIButton) {
        selectImage()
    }
    
    func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let imagePickerActionSheet = UIAlertController(title: "Select a Photo", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerActionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        
        imagePickerActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(imagePickerActionSheet, animated: true)
    }
    
    @IBAction func changeDisplayNameButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func changeUsernameButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: UIButton) {
        
    }
    
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.photo = photo
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
