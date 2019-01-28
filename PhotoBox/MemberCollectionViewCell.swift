//
//  MemberCollectionViewCell.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/23/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class MemberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memberPhotoImageView: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        memberPhotoImageView.layer.cornerRadius = memberPhotoImageView.frame.height / 2
        memberPhotoImageView.clipsToBounds = true
        memberPhotoImageView.contentMode = .scaleAspectFill
    }
  
}
