//
//  SelectPhotosViewController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/30/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit
import Photos

class SelectPhotosViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var unselectButton: UIButton!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var photos: [Photo] = []
    var event: Event?
    var currentUser: AppUser? = UserController.shared.currentUser
    var selectedPhotos = [Photo]()
    var feedDataSource: FeedDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationItem()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 5
        let navigationTitleFont = UIFont(name: "OpenSans-SemiBold", size: 20)
        let navigationTitleColor = UIColor(named: "textDarkGray")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: navigationTitleFont!, NSAttributedString.Key.foregroundColor: navigationTitleColor!]
        activityIndicator.isHidden = true
        uploadButton.layer.cornerRadius = uploadButton.frame.height / 2
        collectionView.allowsMultipleSelection = true
        getPhotosFromLibrary()
        collectionView.dataSource = self
        collectionView.delegate = self
        guard let event = event else { return }
        eventNameLabel.text = event.eventName
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
                    
                    imgManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 2000, height: 2000), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                        image, error in
                        let photo = Photo(image: image, eventID: event.uuid, creatorID: currentUser.uuid, creatorName: currentUser.name)
                        self.photos.append(photo)
                    })
                    collectionView.reloadData()
                }
            } else {
                print("You have no photos")
                self.collectionView.reloadData()
            }
        }

    }
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        guard let event = event, let currentUser = currentUser else { return }
        let selectedPhotos = photos.filter { $0.isSelected }
        PhotoController.shared.upload(photos: selectedPhotos, eventID: event.uuid, userID: currentUser.uuid) { (success) in
            if !success {
                print("Error uploading photos.")
            } else {
                print("Photos successfully updated")
            }
        }
        var newArray: [String] = []
        for photo in selectedPhotos {
            newArray.append(photo.uuid)
            feedDataSource?.photos?.append(photo)
        }
        
        event.photoIDs = newArray
        DispatchQueue.main.async {
            self.update(event: event)
        }
    }
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func update(event: Event) {
        FirebaseManager.updateData(obect: event, dictionary: event.dictionary) { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.activityIndicator.stopAnimating()
                print("photoIDs added to \(event.eventName) 👍")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! SelectPhotosCollectionViewCell
        let photo = photos[indexPath.row]
        cell.photo = photo
        cell.delegate = self
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 4) - 10
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7.0
    }
}

extension SelectPhotosViewController: SelectPhotosCollectionViewCellDelegate {
    
    func photoButtonTapped(sender: SelectPhotosCollectionViewCell) {
        guard let photo = sender.photo else { return }
        photo.isSelected = !photo.isSelected
        sender.updateViews()
    }
}
