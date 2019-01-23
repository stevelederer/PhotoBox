//
//  FriendSearchTableViewCell.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class UserSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfilePictureImageView: UIImageView!
    @IBOutlet weak var usersName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userProfilePictureImageView.layer.cornerRadius = userProfilePictureImageView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
