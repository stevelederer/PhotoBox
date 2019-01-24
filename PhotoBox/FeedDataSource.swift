//
//  FeedDataSource.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/23/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
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
            let imageURLString = photo.imageURL
            var imageData: NSData = NSData()
            if let imageURL: URL = URL(string: imageURLString) {
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        imageData = try NSData(contentsOf: imageURL)
                    } catch {
                        print("There was an error in \(#function) ; \(error.localizedDescription)")
                    }
                    DispatchQueue.main.async {
                        cell.postedImage.image = UIImage(data: imageData as Data)
                        
                        
                    }
                }
            }
            
        }
        return cell
    }
    
}
