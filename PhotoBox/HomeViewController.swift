//
//  HomeViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/22/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var joinEventButton: UIButton!
    @IBOutlet weak var accountDropDownButton: UIButton!
    @IBOutlet weak var settingsDropDown: UITableView!
    
    let settingArray: NSMutableArray = ["Settings", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsDropDown.isHidden = true
        self.setNavigationItem()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
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
            self.performSegue(withIdentifier: "toSettingsScreen", sender: self)
        } else if selectedItem.isEqual(to: "Logout") {
            print("Now logging out...Goodbye!")
            UserController.shared.logOutUser { (success) in
                if success {
                    self.performSegue(withIdentifier: "unwindToLoginPage", sender: self)
                }
            }
        }
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

extension UIViewController {
    func setNavigationItem() {
        let imageView = UIImageView(image: UIImage(named: "boxGraphic"))
        let item = UIBarButtonItem(customView: imageView)
        self.navigationItem.rightBarButtonItem = item
    }
}
