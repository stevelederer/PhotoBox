//
//  BasicUserController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/18/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation

class BasicUserController {
    
    // MARK: - Shared Instance
    
    static let shared = BasicUserController()
    private init () {}
    
    func createBasicUserProfile(from user: AppUser, completion: @escaping (Bool) -> Void) {
        let newBasicProfile = BasicProfile(uuid: user.uuid, username: user.username, name: user.name, profilePicURL: user.profilePicURL)

        FirebaseManager.saveData(object: newBasicProfile) { (error) in
            if let error = error {
                print("There was an error saving basic profile for \(newBasicProfile.name): \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
            return
        }
    }
    
    func changeBasicProfileInfo(user: AppUser, completion: @escaping (Bool) -> Void) {
        let updatedBasicProfile = BasicProfile(uuid: user.uuid, username: user.username, name: user.name, profilePicURL: user.profilePicURL)
        
        FirebaseManager.updateData(obect: updatedBasicProfile, dictionary: updatedBasicProfile.dictionary) { (error) in
            if let error = error {
                print("There was an error updating profile information for \(updatedBasicProfile.name): \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
            return
        }
    }
}
