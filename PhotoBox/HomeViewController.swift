//
//  HomeViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/22/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var joinEventButton: UIButton!
    @IBOutlet weak var accountDropDownButton: UIButton!
    @IBOutlet weak var settingsDropDown: UITableView!
    
    let settingArray: NSMutableArray = ["Settings", "Logout"]
    
    //Source of truth
    var events: [BasicEvent]?
    var currentUser = UserController.shared.currentUser
    
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
        let origButtonImage = UIImage(named: "downArrow")
        let tintedButtonImage = origButtonImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        accountDropDownButton.setImage(tintedButtonImage, for: .normal)
        accountDropDownButton.tintColor = UIColor(named: "buttonPurple")
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height / 2
        createEventButton.layer.cornerRadius = createEventButton.frame.height / 2
        joinEventButton.layer.cornerRadius = joinEventButton.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingsDropDown.isHidden = true
        if let index = self.settingsDropDown.indexPathForSelectedRow {
            self.settingsDropDown.deselectRow(at: index, animated: true)
        }
        settingsDropDown.isHidden = true
        currentUser = UserController.shared.currentUser
        updateViews()
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
    
    @IBAction func createEventButtonTapped(_ sender: UIButton) {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        guard let createEventNav = sb.instantiateInitialViewController() else { return }
//        present(createEventNav, animated: true, completion: nil)
    }
    
    @IBAction func joinEventButtonTapped(_ sender: UIButton) {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let joinEventNav = sb.instantiateViewController(withIdentifier: "EnterCodeViewController")
//        present(joinEventNav, animated: true, completion: nil)
    }
    
    @IBAction func accountDropDownButtonTapped(_ sender: UIButton) {
        let _ = LoginPageViewController()
        if settingsDropDown.isHidden == true {
            settingsDropDown.isHidden = false
        } else {
            settingsDropDown.isHidden = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingsTableViewCell
        cell.cellTextLabel?.text = settingArray[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = settingArray.object(at: indexPath.row) as! NSString
        if selectedItem.isEqual(to: "Settings") {
            toSettingsScreenButtonTapped()
        } else if selectedItem.isEqual(to: "Logout") {
            print("Now logging out...Goodbye!")
            UserController.shared.logOutUser { (success) in
                if success {
                    self.performSegue(withIdentifier: "unwindToLoginPage", sender: self)
                }
            }
        }
    }
    
    func toSettingsScreenButtonTapped() {
        self.performSegue(withIdentifier: "toSettingsScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSettingsScreen" {
            if let destinationVC = segue.destination as? SettingsViewController {
                guard let currentUser = UserController.shared.currentUser else { return }
                destinationVC.currentUser = currentUser
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let events = events else {return 0}
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! AlbumCollectionViewCell
        if let basicEvents = events {
            let event = basicEvents[indexPath.row]
            
            if let basicEventCoverPhotoURLString = event.coverPhotoURL ,
                let coverPhotoURL = URL(string: basicEventCoverPhotoURLString) {
                URLSession.shared.dataTask(with: coverPhotoURL) { (data, _, error) in
                    if let error = error {
                        print(error)
                    }
                    guard let data = data else { return }
                    
                    DispatchQueue.main.async {
                        cell.albumImageView.image = UIImage(data: data)
                        cell.eventName.text = event.eventName
                        cell.eventTime.text = event.formattedEndTime
                    }
                }
            } else {
                // FIXME: - Have a default cover photo display if no cover photo URL
            }
        }
        
        return cell
    
    }
    
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
