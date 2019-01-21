//
//  UserController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/18/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class UserController {
    
    // MARK: - Shared Instance
    
    static let shared = UserController()
    private init (){}
    
    // MARK: - Source of Truth
    
    var currentUser: AppUser? {
        didSet {
            print("Current AppUser is now: \(String(describing: currentUser?.username))")
        }
    }
    
    // MARK: - User Functions
    
    func checkForLoggedInUser(completion: @escaping (Bool) -> Void) {
        FirebaseManager.getLoggedInUser { (currentLoggedInUser) in
            if let currentLoggedInUser = currentLoggedInUser {
                self.currentUser = currentLoggedInUser
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    func signInUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        FirebaseManager.signIn(email: email, password: password) { (signedInUser) in
            if let signedInUser = signedInUser {
                self.currentUser = signedInUser
                completion(true)
                return
            } else {
                completion(false)
                return
            }
        }
    }
    
    func signUpUser(name: String, email: String, username: String, password: String, completion: @escaping (Bool) -> Void) {
        FirebaseManager.signUp(name: name, email: email, username: username, password: password) { (firebaseUser, error) in
            if let error = error {
                print("Error saving a new user to the Firebase Database: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let newUser = firebaseUser {
                self.currentUser = newUser
                BasicUserController.shared.createBasicUserProfile(from: newUser, completion: completion)
                return
            }
        }
    }
    
    func signOutUser(user: AppUser, completion: @escaping (Bool) -> Void) {
        FirebaseManager.signOut(user: user) { (error) in
            if let error = error {
                print("There was an error signing out user \(user.username). \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
                return
            }
        }
    }
    
    func forgotPassword(email: String, completion: @escaping (Bool) -> Void) {
        FirebaseManager.forgotPassword(email: email) { (success) in
            if success {
                print("Successfully sent password reset email to \(email)")
                completion(true)
                return
            } else {
                print("There was a problem sending password reset email to \(email)")
                completion(false)
                return
            }
        }
    }
    
    func changeUserInfo(user: AppUser, completion: @escaping (Bool) -> Void) {
        FirebaseManager.updateData(obect: user, dictionary: user.dictionary) { (error) in
            if let error = error {
                print("There was an error updating \(user.name): \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
        BasicUserController.shared.changeBasicProfileInfo(user: user, completion: completion)
    }
    
    
}
