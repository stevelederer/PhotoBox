//
//  PhotoController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/25/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit
import Firebase

extension PhotoController {
    static let ProfilePicDownloadedNotification = Notification.Name("ProfilePicDownloadedNotification")
}

class PhotoController {
    
    static let shared = PhotoController()
    
    func fetchProfileImages(for basicProfile: BasicProfile, completion: @escaping (UIImage?) -> Void) {
        guard let profilePicURL = basicProfile.profilePicURL else { return }
        FirebaseManager.fetchPhotoFromFirebase(url: profilePicURL) { (success, profilePic) in
            if !success {
                print("there was an error fetching the profile picture for user: \(basicProfile.name)")
                completion(nil)
                return
            } else {
                completion(profilePic)
                return
            }
        }
    }
    
    func fetchPhotos(for event: Event, completion: @escaping ([Photo]?) -> Void) {
        guard let photoIDs = event.photoIDs else { return }
        let dispatchGroup = DispatchGroup()
        
        var photos: [Photo] = []
        for photoID in photoIDs {
            dispatchGroup.enter()
            FirebaseManager.fetchFromFirestore(uuid: photoID) { (photo: Photo?) in
                if let photo = photo {
                    photos.append(photo)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(photos)
        }
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (UIImage?) -> Void) {
        if let url = photo.imageURL {
            FirebaseManager.fetchPhotoFromFirebase(url: url, completion: { (success, image) in
                if !success {
                    completion(nil)
                    return
                }
                if let image = image {
                    completion(image)
                }
            })
        }
    }
}






