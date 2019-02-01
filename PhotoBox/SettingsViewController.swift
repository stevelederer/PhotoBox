//
//  SettingsViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/23/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
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
    @IBOutlet weak var logOutButton: UnderlineButtonTextPurple!
    @IBOutlet weak var eventReminderNotificationSwitch: UISwitch!
    
    var currentUser: AppUser?
    
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
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 5
        let navigationTitleFont = UIFont(name: "OpenSans-SemiBold", size: 20)
        let navigationTitleColor = UIColor(named: "textDarkGray")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: navigationTitleFont!, NSAttributedString.Key.foregroundColor: navigationTitleColor!]
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height / 2
        changePictureButton.setTitle("Change Picture", for: .normal)
        changeDisplayNameButton.setTitle("Change Display Name", for: .normal)
        changeUsernameButton.setTitle("Change Username", for: .normal)
        deleteAccountButton.setTitle("Delete Account", for: .normal)
        logOutButton.setTitle("Log Out", for: .normal)
        eventReminderNotificationSwitch.layer.borderColor = UIColor(named: "darkGrayText")?.cgColor
        eventReminderNotificationSwitch.layer.borderWidth = 2
        eventReminderNotificationSwitch.layer.cornerRadius = eventReminderNotificationSwitch.frame.height / 2

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
    }
    
    func updateViews() {
        guard let currentUser = currentUser else { return }
        
        displayNameLabel.text = currentUser.name
        usernameLabel.text = currentUser.username
        profilePicImageView.image = currentUser.profilePic
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
        guard let currentUser = currentUser else { return }
        let changeDisplayNameAlert = UIAlertController(title: "Change Name", message: "Current Display Name is \(currentUser.name)", preferredStyle: .alert)
        changeDisplayNameAlert.addTextField { (textField) in
            textField.placeholder = "New Display Name"
        }
        changeDisplayNameAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (okayAction) in
            guard let newDisplayNameText = changeDisplayNameAlert.textFields?.first?.text else { return }
            self.displayNameLabel.text = newDisplayNameText
            self.currentUser?.name = newDisplayNameText
            self.saveChangesToFirebase()
        }))
        changeDisplayNameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(changeDisplayNameAlert, animated: true)
    }
    
    @IBAction func changeUsernameButtonTapped(_ sender: UIButton) {
        guard let currentUser = currentUser else { return }
        let changeUsernameAlert = UIAlertController(title: "Change Username", message: "Current Username is \(currentUser.username)", preferredStyle: .alert)
        changeUsernameAlert.addTextField { (textField) in
            textField.placeholder = "New Username"
        }
        changeUsernameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        changeUsernameAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (okayAction) in
            guard let newUsernameText = changeUsernameAlert.textFields?.first?.text else { return }
            self.usernameLabel.text = newUsernameText
            self.currentUser?.username = newUsernameText
            self.saveChangesToFirebase()
        }))
        present(changeUsernameAlert, animated: true)
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: UIButton) {
        FirebaseManager.deleteLoggedInUser { (success) in
            if success {
                print("✅ User Successfully Deleted")
            } else {
                print("Error deleting user")
            }
        }
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        
    }
    
    func saveChangesToFirebase() {
        guard let currentUser = currentUser else { return }
        UserController.shared.changeUserInfo(user: currentUser) { (success) in
            if !success {
                print("Error saving user changes to cloud database.")
            }
        }
    }
    
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.photo = photo
            currentUser?.profilePic = photo
            guard let currentUser = currentUser else { return }
            let newPhoto = Photo(image: photo, eventID: "", creatorID: currentUser.uuid, creatorName: currentUser.name)
            FirebaseManager.uploadPhotoToFirebase(newPhoto) { (url, error) in
                if let error = error {
                    print("There was an error uploading to Firebase Storage: \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    currentUser.profilePicURL = "\(url)"
                    newPhoto.imageURL = "\(url)"
                    UserController.shared.changeUserInfo(user: currentUser, completion: { (success) in
                        if success {
                            print("Success updating current user info")
                        } else {
                            print("error updating current user info")
                        }
                    })
                    FirebaseManager.saveData(object: newPhoto, completion: { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                    })
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
