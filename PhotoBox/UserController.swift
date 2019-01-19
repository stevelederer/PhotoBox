//
//  UserController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/18/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class UserController {
    
    static let shared = UserController()
    private init (){}
    
    var currentUser: AppUser? {
        didSet {
            print("Current User is: \(String(describing: currentUser?.username))")
        }
    }
    
    func signUpUser(name: String, email: String, username: String, password: String, completion: @escaping (Bool) -> Void) {
        FirebaseManager.shared.auth(name: name, email: email, username: username, password: password) { (newUser) in
            if let newUser = newUser {
                self.currentUser = newUser
                
                //basicusercontroller.shared.create(newuser, completion(true)
                
                completion(true)
                return
            }
        }
    }
    
    func updateUser(userame: String?, name: String?, profilePic: UIImage?) {
        
    }
}
