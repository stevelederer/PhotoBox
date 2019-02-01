//
//  PhotoCollectionViewCell.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/23/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

protocol PhotoCollectionViewCellDelegate: class {
    func optionButtonTapped(sender: PhotoCollectionViewCell)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var usersName: UILabel!
    @IBOutlet weak var usersProfilePic: UIImageView!
    @IBOutlet weak var moreOptionsButton: UIButton!
    
    var photo: Photo?
    
    weak var delegate: PhotoCollectionViewCellDelegate?
    
    @IBAction func moreOptionsButtonTapped(_ sender: UIButton) {
        delegate?.optionButtonTapped(sender: self)
    }
    
}
