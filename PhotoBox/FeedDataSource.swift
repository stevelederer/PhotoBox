//
//  FeedDataSource.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/23/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class FeedDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var photos: [Photo]?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photos = photos else {return 0}
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "liveFeedCell", for: indexPath) as! FeedCollectionViewCell
        if let photoArray = photos {
            let photo = photoArray[indexPath.row]
            PhotoController.shared.fetchImage(for: photo) { (image) in
                DispatchQueue.main.async {
                    photo.image = image
                    cell.postedImage.image = image
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "\(FeedHeaderView.self)",
                    for: indexPath) as? FeedHeaderView
                else {
                    fatalError("Invalid view type")
            }
            headerView.label.text = "Live Feed"
            headerView.button.setTitle("My Photos", for: .normal)
            return headerView
        default:
            assert(false, "Invalid element type")
        }
        return UICollectionReusableView()
    }
    
}
