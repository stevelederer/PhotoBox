//
//  PhotoDetailViewController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/23/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var photos: [Photo] = [] {
        didSet {
            loadViewIfNeeded()
            updateView()
        }
    }
    
    let emailComposer = MessageComposer()
    
    var selectedPosition: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.isPagingEnabled = true
        photoCollectionView.frame = view.frame
        
    }
    
    func updateView() {
        photoCollectionView.reloadData()
        guard photoCollectionView.numberOfItems(inSection: 0) >=  selectedPosition else { return }
        let indexPath = IndexPath(row: selectedPosition, section: 0)
        photoCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
}

extension PhotoDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoDetailCell", for: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.row]
        cell.photo = photo
        if let image = photo.image {
            cell.postedImage.image = image
            cell.delegate = self
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

extension PhotoDetailViewController: PhotoCollectionViewCellDelegate {
    
    func optionButtonTapped(sender: PhotoCollectionViewCell) {
        guard let photo = sender.photo else { return }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let image = photo.image else { return }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            self.presentPhotoBoxModalVC(message: "Photo Saved!")
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            
        }
        
        let reportPhotoAction = UIAlertAction(title: "Report Photo", style: .default) { (_) in
            if (self.emailComposer.canSendEmail()) {
                let emailComposerVC = self.emailComposer.composePhotoReportEmailWith(photo: photo)
                self.present(emailComposerVC, animated: true, completion: nil)
            }
        }
        
        let blockerUserAction = UIAlertAction(title: "Block User", style: .default) { (_) in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(deleteAction)
        alertController.addAction(reportPhotoAction)
        alertController.addAction(blockerUserAction)
        alertController.addAction(cancelAction)
        // add rest of actions ^
        
        present(alertController, animated: true, completion: nil)
    }
    
}
