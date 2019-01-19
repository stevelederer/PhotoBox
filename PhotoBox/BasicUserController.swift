//
//  BasicUserController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/18/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation

class BasicUserController {
    
    static let shared = BasicUserController()
    private init () {}
    
    func create(user: AppUser, completion: @escaping (Bool) -> Void) {
        BasicProfile(uuid: user.uuid, name: user.name, profilePicURL: user.profilePicURL)
        FirebaseManager.shared.saveData(object: BasicProfile) { (error) in
            if let error = error {
                print("There was an error saving basig profile for \(user): \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
            return
        }
        
    }
    
    
    
    
}
