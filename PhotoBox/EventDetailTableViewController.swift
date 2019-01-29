//
//  EventDetailTableViewController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/23/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class EventDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var eventCoverPhotoImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var memberCollectionView: UICollectionView!
    @IBOutlet weak var liveFeedCollectionView: UICollectionView!
    @IBOutlet weak var expandCollapseButton: UIButton!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var collectionIsExpanded = false
    let membersCollectionViewCellHeight: CGFloat = 84
    var membersTableViewCellHeight: CGFloat = 0
    var expandedTableViewCellHeight: CGFloat {
        return determineTableViewCellHeight()
    }
    var numberOfMemberRows = 0
    var numberOfMembers: Int?
    var row4Height: CGFloat = 0
    
    var memberDataSource = MemberDataSource()
    var feedDataSource = FeedDataSource()
    let messageComposer = MessageComposer()
    
    //Landing Pad
    var event: Event?
    var currentUser: AppUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "buttonPurple")
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "buttonPurple")
        inviteButton.layer.cornerRadius = inviteButton.frame.height / 2
        membersTableViewCellHeight = membersCollectionViewCellHeight + 52
        // Set both collection view data source's to respective data source
        memberCollectionView.dataSource = memberDataSource
        liveFeedCollectionView.dataSource = feedDataSource
        updateViews()
        guard let event = event else { return }
        EventController.shared.fetchMembers(for: event) { (fetchedMembers) in
            if let fetchedMembers = fetchedMembers {
                self.numberOfMembers = fetchedMembers.count
                if fetchedMembers.count <= 5 {
                    self.expandCollapseButton.isHidden = true
                } else {
                    self.expandCollapseButton.isHidden = false
                    self.tableView.beginUpdates()
                    self.row4Height = 44
                    self.tableView.endUpdates()
                }
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

        guard let coverPhotoURL = event.coverPhotoURL else { return }
        FirebaseManager.fetchPhotoFromFirebase(url: coverPhotoURL) { (success, backgroundImage) in
            if success {
                event.coverPhoto = backgroundImage
                DispatchQueue.main.async {
                    self.eventCoverPhotoImageView.image = backgroundImage
                }
            } else {
                print("🚨 No cover photo downloaded.")
            }
        }
        
    }
    
    // MARK: - Setup
    
    func updateViews() {
        guard let event = event else { return }
        FirebaseManager.fetchFromFirestore(uuid: event.creatorID) { (user: AppUser?) in
            if let user = user {
                DispatchQueue.main.async {
                    self.creatorLabel.text = "Event Host: \(user.name)"
                }
            }
        }
        eventNameLabel.text = event.eventName
        startDateLabel.text = "Date: \(event.formattedStartTime)"
        guard let location = event.location,
            !location.isEmpty else { eventLocationLabel.isHidden = true ; return }
        eventLocationLabel.text = "Location: \(location)"
        eventCoverPhotoImageView.image = event.coverPhoto
        detailsLabel.text = event.details
    }
    
    //   MARK: - Actions
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToHomePage", sender: self)
    }
    
    @IBAction func invitePeopleButtonTapped(_ sender: Any) {
        if (messageComposer.canSendText()) {
            guard let code = event?.eventCode,
                let creator = currentUser?.name,
                let name = event?.eventName else { return }
            let messageComposerVC = messageComposer.configuredMessageComposeViewController(eventName: name, code: code, creator: creator)
            
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
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: [.curveEaseInOut], animations: {
                sender.transform = buttonRotateClockwise
                self.tableView.beginUpdates()
                self.membersTableViewCellHeight = self.expandedTableViewCellHeight
                self.tableView.endUpdates()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: [.curveEaseInOut], animations: {
                sender.transform = .identity
                self.tableView.beginUpdates()
                self.membersTableViewCellHeight = self.membersCollectionViewCellHeight + 52
                self.tableView.endUpdates()
            }, completion: nil)
        }
        collectionIsExpanded = !collectionIsExpanded
    }
    
    func determineTableViewCellHeight() -> CGFloat {
        guard let numberOfMembers = memberDataSource.members?.count else { return 0 }
        if numberOfMembers > 5 {
            if numberOfMembers % 5 >= 1 {
                numberOfMemberRows = (numberOfMembers / 5) + 1
            } else {
                numberOfMemberRows = numberOfMembers / 5
            }
            let cellHeight = self.membersCollectionViewCellHeight
            return (CGFloat(numberOfMemberRows) * cellHeight) + CGFloat(((numberOfMemberRows - 1) * 16) + 52)
        } else if numberOfMembers <= 5 {
            return self.membersCollectionViewCellHeight + 52
        }
        return self.membersCollectionViewCellHeight
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 128
            } else if indexPath.row == 1 || indexPath.row == 2 {
                return 64
            } else if indexPath.row == 3 {
                return membersTableViewCellHeight
            } else if indexPath.row == 4 {
                return self.row4Height
            } else {
                return 248
            }
        } else {
            return UITableView.automaticDimension
        }
    }
    
}
