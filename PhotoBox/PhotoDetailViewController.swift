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
    
    var selectedPosition: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.isPagingEnabled = true
        photoCollectionView.frame = view.frame
        
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            // Save functionality here
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            
        }
        
        let reportPhotoAction = UIAlertAction(title: "Report Photo", style: .default) { (_) in
            
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
    
    func updateView() {
        photoCollectionView.reloadData()
        guard photoCollectionView.numberOfItems(inSection: 0) >=  selectedPosition else { return }
        let indexPath = IndexPath(row: selectedPosition, section: 0)
        photoCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    @IBAction func handleSelection(_ sender: Any) {
    }
    
   
    
    //
//    @IBAction func handleSelection(_ sender: UIButton) {
//        optionsButton.forEach { (button) in
//            UIView.animate(withDuration: 0.3, animations: {
//                button.isHidden = !button.isHidden
//                self.view.layoutIfNeeded()
//            })
//        }
//        
//    }
    
    
    
}

extension PhotoDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoDetailCell", for: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.row]
        if let image = photo.image {
            cell.postedImage.image = image
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
