//
//  PhotoController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/25/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit
import Firebase

extension PhotoController {
    static let ProfilePicDownloadedNotification = Notification.Name("ProfilePicDownloadedNotification")
}

class PhotoController {
    
    static let shared = PhotoController()
    let messageComposer = MessageComposer()
    
    func fetchProfileImages(for appUser: AppUser, completion: @escaping (UIImage?) -> Void) {
        guard let profilePicURL = appUser.profilePicURL else { return }
        FirebaseManager.fetchPhotoFromFirebase(url: profilePicURL) { (success, profilePic) in
            if !success {
                print("there was an error fetching the profile picture for user: \(appUser.name)")
                completion(nil)
                return
            } else {
                completion(profilePic)
                return
            }
        }
    }
    
    func fetchPhotos(for event: Event, completion: @escaping ([Photo]?) -> Void) {
        guard var photoIDs = event.photoIDs,
        let currentUser = UserController.shared.currentUser else { return }
        let dispatchGroup = DispatchGroup()
        
        if let blockedUserIDs = currentUser.blockedUserIDs {
            for blockedUserID in blockedUserIDs {
                photoIDs = photoIDs.filter{ $0 == blockedUserID }
            }
        }
        
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
    
    func upload(photos: [Photo], eventID: String, userID: String, completion: @escaping (Bool) -> Void) {
        for photo in photos {
            FirebaseManager.uploadPhotoToFirebase(photo) { (url, error) in
                if let error = error {
                    print("There was an error uploading image to cloud storage: \(error.localizedDescription)")
                    completion(false)
                    return
                } else {
                    guard let url = url else { return }
                    photo.imageURL = "\(url)"
                    FirebaseManager.saveData(object: photo, completion: { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                    })
                    completion(true)
                }
            }
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
    
    func saveProfilePhoto(from image: UIImage, user: AppUser, completion: @escaping (String?) -> Void) {
        let newPhoto = Photo(image: image, uuid: user.uuid, eventID: "", creatorID: "", creatorName: "")
        FirebaseManager.uploadPhotoToFirebase(newPhoto) { (url, error) in
            if let error = error {
                print("There was an error uploading to cloud storage: \(error.localizedDescription)")
                completion(nil)
                return
            } else {
                guard let url = url else { return }
                do {
                    let urlAsString = try String(contentsOf: url)
                    user.profilePicURL = urlAsString
                    completion(urlAsString)
                } catch {
                    print("❌ There was an error in \(#function) ; \(error.localizedDescription)❌")
                }
            }
        }
    }
}






