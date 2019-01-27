//
//  UserController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/18/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit
import FirebaseFirestore

class UserController {
    
    // MARK: - Shared Instance
    
    static let shared = UserController()
    private init (){}
    
    // MARK: - Source of Truth
    
    var currentUser: AppUser? {
        didSet {
            if let currentUser = currentUser {
                print("👤👤👤 Current AppUser Username is: \(currentUser.username) 👤👤👤")
            }
        }
    }
    
    var basicEventCache: NSCache<NSString, BasicEvent> = NSCache()
    var userEvents: [BasicEvent] = []
    
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
    
    func logInUser(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        FirebaseManager.logInWith(email: email, password: password) { (loggedInUser, error) in
            if let error = error {
                print("Error signing in user: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            if let loggedInUser = loggedInUser {
                self.currentUser = loggedInUser
                completion(true, nil)
                return
            }
        }
    }
    
    func signUpUser(name: String, email: String, username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        FirebaseManager.signUp(name: name, email: email, username: username, password: password) { (firebaseUser, error) in
            if let error = error {
                print("Error saving a new user to the Firebase Database: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            if let newUser = firebaseUser {
                self.currentUser = newUser
                BasicUserController.shared.createBasicUserProfile(from: newUser, completion: { (success) in
                    if !success {
                        print("Error creating basic user from new user: \(newUser.name)")
                        completion(false, nil)
                        return
                    } else {
                        completion(true, nil)
                    }
                })
                return
            }
        }
    }
    
    func logOutUser(completion: @escaping (Bool) -> Void) {
        guard let currentUser = currentUser else { return }
        FirebaseManager.signOut() { (error) in
            if let error = error {
                print("There was an error signing out user \(currentUser.name). \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            } else {
                self.currentUser = nil
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
            self.currentUser = user
        }
        BasicUserController.shared.changeBasicProfileInfo(user: user, completion: completion)
    }
    
    func fetchBasicEventInfo(for eventID: String, completion: @escaping (BasicEvent) -> Void) {
        if let basicEvent = basicEventCache.object(forKey: NSString(string: eventID)) {
            completion(basicEvent)
        } else {
            FirebaseManager.fetchBasicEvent(for: eventID) { basicEvent in
                if let basicEvent = basicEvent {
                    self.basicEventCache.setObject(basicEvent, forKey: NSString(string: eventID))
                    completion(basicEvent)
                }
            }
        }
    }
    
    func blockUser(with uuid: String, completion: @escaping (Bool) -> Void) {
        guard let currentUser = currentUser else { completion(false) ; return }
        
        Firestore.firestore().collection("users").document(currentUser.uuid).updateData(["blockedUserIDs" : FieldValue.arrayUnion([uuid])]) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            } else {
                currentUser.blockedUserIDs?.append(uuid)
                UserController.shared.changeUserInfo(user: currentUser, completion: { (_) in
                    
                })
                completion(true)
            }
        }
    }
}
