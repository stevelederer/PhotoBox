//
//  EventDetailTableViewController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/23/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class EventDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var memberCollectionView: UICollectionView!
    @IBOutlet weak var liveFeedCollectionView: UICollectionView!
    @IBOutlet weak var expandCollapseButton: UIButton!
    
    var collectionIsExpanded = false
    var membersCollectionViewCellHeight: CGFloat {
        return memberCollectionView.frame.height
    }
    var membersTableViewCellHeight: CGFloat = 0
    var expandedTableViewCellHeight: CGFloat {
        return determineTableViewCellHeight()
    }
    var numberOfRows = 0
    
    var memberDataSource = MemberDataSource()
    var feedDataSource = FeedDataSource()
    let messageComposer = MessageComposer()
    
    //Landing Pad
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "buttonPurple")
        membersTableViewCellHeight = membersCollectionViewCellHeight
        // Set both collection view data source's to respective data source
        memberCollectionView.dataSource = memberDataSource
        liveFeedCollectionView.dataSource = feedDataSource
        guard let event = event else { return }
        EventController.shared.fetchMembers(for: event) { (fetchedMembers) in
            if let fetchedMembers = fetchedMembers {
                self.memberDataSource.members = fetchedMembers
                DispatchQueue.main.async {
                    self.memberCollectionView.reloadData()
                }
            }
        }
        
        PhotoController.shared.fetchPhotos(for: event) { (photos) in
            self.feedDataSource.photos = photos
            DispatchQueue.main.async {
                self.liveFeedCollectionView.reloadData()
            }
        }
    }
    
    //   MARK: - Actions
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToHomePage", sender: self)
    }
    
    
    
    @IBAction func invitePeopleButtonTapped(_ sender: Any) {
        if (messageComposer.canSendText()) {
            guard let code = event?.eventCode,
                let name = event?.eventName else { return }
            let messageComposerVC = messageComposer.configuredMessageComposeViewController(eventName: name, code: code)
            
            present(messageComposerVC, animated: true, completion: nil)
        } else {
            let errorAlert = UIAlertController(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            present(errorAlert, animated: true)
        }
    }
    
    @objc func reloadCollection() {
        memberCollectionView.reloadData()
    }
    
    @IBAction func expandCollapseButtonTapped(_ sender: UIButton) {
        let buttonRotateClockwise = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        if !collectionIsExpanded {
            UIView.animate(withDuration: 0.3) {
                sender.transform = buttonRotateClockwise
                self.tableView.beginUpdates()
                self.membersTableViewCellHeight = self.membersCollectionViewCellHeight
                self.tableView.endUpdates()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                sender.transform = .identity
                self.tableView.beginUpdates()
                self.membersTableViewCellHeight = self.expandedTableViewCellHeight
                self.tableView.endUpdates()
            }
        }
        collectionIsExpanded = !collectionIsExpanded
    }
    
    func determineTableViewCellHeight() -> CGFloat {
//        guard let numberOfMembers = memberDataSource.members?.count else { return 0 }
        let numberOfMembers = 20
        if numberOfMembers > 5 {
            if numberOfMembers % 5 >= 1 {
                numberOfRows = (numberOfMembers / 5) + 1
            } else {
                numberOfRows = numberOfMembers / 5
            }
            let cellHeight = self.membersCollectionViewCellHeight
            return (CGFloat(numberOfRows) * cellHeight) + CGFloat(((numberOfRows - 1) * 16))
        } else if numberOfMembers <= 5 {
            return self.membersCollectionViewCellHeight
        }
        return self.membersCollectionViewCellHeight
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1 {
            return membersTableViewCellHeight
        } else {
            return 248
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
