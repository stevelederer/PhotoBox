//
//  SelectPhotosCollectionViewCell.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/30/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

protocol SelectPhotosCollectionViewCellDelegate: class {
    
    func photoButtonTapped(sender: SelectPhotosCollectionViewCell)
}

class SelectPhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var checkmark: UIImageView!
    var photo: Photo? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: SelectPhotosCollectionViewCellDelegate?
    
    override var isSelected: Bool {
        didSet {
        }
    }
    
    @IBAction func selectButtonTapped(_ sender: Any) {
        delegate?.photoButtonTapped(sender: self)
    }
    
    func updateViews() {
        guard let photo = photo else { return }
        
        checkmark.isHidden = !photo.isSelected
        imageButton.setBackgroundImage(photo.image, for: .normal)
        if photo.isSelected {
            imageButton.layer.borderWidth =  5
            imageButton.layer.borderColor = UIColor.darkGray.cgColor
        } else {
            imageButton.layer.borderWidth = 0
        }
    }
    
}
