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
    var collectionCellHeight = 130
    
    var memberDataSource = MemberDataSource()
    var feedDataSource = FeedDataSource()
    let messageComposer = MessageComposer()
    
    //Landing Pad
    var event: Event?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberCollectionView.dataSource = memberDataSource
        liveFeedCollectionView.dataSource = feedDataSource
        // Set both collection view data source's to respective data source
    }
    
    //   MARK: - Actions
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
    
    @IBAction func expandCollapseButtonTapped(_ sender: UIButton) {
        let buttonRotateClockwise = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        if !collectionIsExpanded {
            UIView.animate(withDuration: 0.3) {
                sender.transform = buttonRotateClockwise
                self.tableView.beginUpdates()
                self.collectionCellHeight = 250
                self.tableView.endUpdates()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                sender.transform = .identity
                self.tableView.beginUpdates()
                self.collectionCellHeight = 130
                self.tableView.endUpdates()
            }
        }
        collectionIsExpanded = !collectionIsExpanded
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1 {
            return CGFloat(collectionCellHeight)
//            let numberOfRows = (numberOfPhotos / 5) + (numberOfPhotos % 5)
//            let expandedHeight = (numberOfRows * rowHeight) + ((numberOfRows - 1) * rowSpacing)
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
