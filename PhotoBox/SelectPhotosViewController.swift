//
//  SelectPhotosViewController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/30/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit
import Photos

class SelectPhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var photos: [Photo] = []
    var event: Event?
    var currentUser: AppUser? = UserController.shared.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsMultipleSelection = true
        getPhotosFromLibrary()
        
    }
    func getPhotosFromLibrary() {
        
        guard let event = event else { return }
        
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        let startDate = Date(timeIntervalSince1970: event.startTime) as NSDate
        let endDate = Date(timeIntervalSinceNow: event.endTime) as NSDate
        
        let startTimePredicate = NSPredicate(format: "creationDate > %@", startDate)
        let endTimePredicate = NSPredicate(format:"creationDate < %@", endDate)
        let combinePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [startTimePredicate, endTimePredicate])
        fetchOptions.predicate = combinePredicate
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        
        guard let currentUser = currentUser else { return }
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    
                    imgManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 150, height: 150), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                        image, error in
                        let photo = Photo(image: image, eventID: event.uuid, creatorID: currentUser.uuid)
                        self.photos.append(photo)
                    })
                    collectionView.reloadData()
                }
            } else {
                print("You have no photos")
                self.collectionView.reloadData()
            }
        }

        let selectedPhotos = photos.filter { $0.isSelected }
        PhotoController.shared.upload(photos: selectedPhotos, eventID: event.uuid, userID: currentUser.uuid) { (success) in
            if !success {
                print("Error uploading photos.")
            } else {
                print("Photos successfully updated")
            }
        }
    }
    
    @IBAction func imageSelectedButtonTapped(_ sender: UIButton) {
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! SelectPhotosCollectionViewCell
        let photo = photos[indexPath.row]
        if photo.isSelected == true {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        } else {
            cell.isSelected = false
        }
        cell.photoImageView.image = photo.image
        return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 4) - 10
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        photo.isSelected = !photo.isSelected
        collectionView.reloadItems(at: [indexPath])
        
    }
//    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        selectedImage.remove(indexPath)
//        collectionView.reloadItems(at: [indexPath])
//    }
}
    
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        

