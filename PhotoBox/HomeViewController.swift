//
//  HomeViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/22/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit
import UserNotifications

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UNUserNotificationCenterDelegate  {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var joinEventButton: UIButton!
    @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    //Source of truth
    var events: [Event]? {
        didSet {
            self.albumCollectionView.reloadData()
        }
    }
    var currentUser = UserController.shared.currentUser
    var eventIDFromNotification: String?
    var fromNotification = false
    
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
        joinEventButton.layer.cornerRadius = joinEventButton.frame.height / 2
        joinEventButton.layer.borderColor = UIColor(named: "buttonGreen")?.cgColor
        joinEventButton.layer.borderWidth = 3
        
        fetchEvents()
        
        if fromNotification == true {
            guard let eventDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "eventDetailVC") as? EventDetailTableViewController else { return }
            eventDetailVC.eventID = eventIDFromNotification
            eventDetailVC.fromNotification = true
            self.navigationController?.pushViewController(eventDetailVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
        fetchEvents()

    }
    
    func fetchEvents() {
        guard let currentUser = currentUser else { return }
        FirebaseManager.fetchFirestoreWithFieldAndCriteria(for: "memberIDs", criteria: currentUser.uuid, inArray: true) { (events: [Event]?) in
            if let events = events {
                self.events = events
            }
        }
    }
    
    func updateViews() {
        displayNameLabel.text = currentUser?.name
        usernameLabel.text = currentUser?.username
        if let url = currentUser?.profilePicURL {
            FirebaseManager.fetchPhotoFromFirebase(url: url) { (_, image) in
                if let image = image {
                    self.profilePicImageView.image = image
                    self.currentUser?.profilePic = image
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "FirstEventEndReminder" {
            self.eventIDFromNotification = response.notification.request.content.userInfo["eventID"] as? String
            self.performSegue(withIdentifier: "toEventDetailVC", sender: self)
        }
        completionHandler()
    }
    
    @IBAction func createEventButtonTapped(_ sender: UIButton) { }
    
    @IBAction func joinEventButtonTapped(_ sender: UIButton) { }
    
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toSettingsScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSettingsScreen" {
            if let destinationVC = segue.destination as? SettingsViewController {
                guard let currentUser = UserController.shared.currentUser else { return }
                destinationVC.currentUser = currentUser
            }
        } else if segue.identifier == "toEventDetailVC" {
            if let destinationVC = segue.destination as? EventDetailTableViewController {
                guard let currentUser = UserController.shared.currentUser else { return }
                guard let eventID = self.eventIDFromNotification else { return }
                destinationVC.eventID = eventID
            }
        } else if segue.identifier == "albumToDetail" {
            if let destinationVC = segue.destination as? EventDetailTableViewController,
                let indexPath = albumCollectionView.indexPathsForSelectedItems?.first,
                let event = events?[indexPath.row - 1] {
                   destinationVC.event = event
                }
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let events = events else {return 1}
        return events.count + 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let createPhotoBoxCell = collectionView.dequeueReusableCell(withReuseIdentifier: "createPhotoBox", for: indexPath) as! CreateNewPhotoBoxCollectionViewCell
            return createPhotoBoxCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath) as! AlbumCollectionViewCell
            
            if let events = events {
                let event = events[indexPath.row - 1]
                if let coverPhotoURL = event.coverPhotoURL {
                    FirebaseManager.fetchPhotoFromFirebase(url: coverPhotoURL) { (success, image) in
                        if success {
                            DispatchQueue.main.async {
                                cell.albumImageView.image = image
                                cell.eventName.text = event.eventName
                                cell.eventTime.text = event.shortFormattedEndTime
                            }
                        }
                    }
                }
            }
            return cell
        }
    }
    
//                if let basicEventCoverPhotoURLString = event.coverPhotoURL,
//                    let coverPhotoURL = URL(string: basicEventCoverPhotoURLString) {
//                    URLSession.shared.dataTask(with: coverPhotoURL) { (data, _, error) in
//                        if let error = error {
//                            print(error)
//                        }
//                        guard let data = data else { return }
//
//                        DispatchQueue.main.async {
//                            cell.albumImageView.image = UIImage(data: data)
//                            cell.eventName.text = event.eventName
//                            cell.eventTime.text = event.formattedEndTime
//                        }
//                    }
//                } else {
//                    // FIXME: - Have a default cover photo display if no cover photo URL
//                }
    
    
    @IBAction func unwindToHomePage(segue:UIStoryboardSegue) {
    }
    
}

extension UIViewController {
    func setNavigationItem() {
        let imageView = UIImageView(image: UIImage(named: "boxGraphic"))
        let item = UIBarButtonItem(customView: imageView)
        self.navigationItem.rightBarButtonItem = item
    }
}
