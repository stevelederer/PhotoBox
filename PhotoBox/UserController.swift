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
            print("✅✅✅ Current AppUser is: \(String(describing: currentUser?.username))")
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
    
    func signInUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        FirebaseManager.signIn(email: email, password: password) { (signedInUser) in
            if let signedInUser = signedInUser {
                self.currentUser = signedInUser
                completion(true)
                return
            } else {
                completion(false)
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
        }
        BasicUserController.shared.changeBasicProfileInfo(user: user, completion: completion)
    }
    
    func searchForUser(with searchTerm: String, completion: @escaping ([BasicProfile]?) -> Void) {
        let basicUsersRef = Firestore.firestore().collection("BasicProfile")
        basicUsersRef.whereField("name", arrayContains: searchTerm).getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            } else {
                guard let documents = querySnapshot?.documents else { completion(nil) ; return }
                var returnedUsers: [BasicProfile] = []
                for document in documents {
                    let documentDictionary = document.data()
                    guard let newBasicProfile = BasicProfile(with: documentDictionary, id: document.documentID) else { completion(nil) ; return }
                    returnedUsers.append(newBasicProfile)
                }
                completion(returnedUsers)
            }
        }
    }
    
//    func fetchEventsFor(user: AppUser, completion: @escaping (Bool) -> Void) {
//        guard let eventIDs = user.memberEventIDs else { completion(false) ; return }
//        for eventID in eventIDs {
//            fetchBasicEventInfo(for: eventID) { (basicEvent) in
//                self.userEvents.append(basicEvent)
//                completion(true)
//            }
//        }
//    }
    
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
    
//    func requestFriend(userID: String, completion: @escaping (Bool) -> Void) {
//        guard let currentUser = currentUser else { completion(false) ; return }
//        let requestorID = currentUser.uuid
//        Firestore.firestore().collection("users").document(userID).updateData(["connectionInviteIDs" : FieldValue.arrayUnion([requestorID])]) { (error) in
//            if let error = error {
//                print(error.localizedDescription)
//                completion(false)
//                return
//            } else {
//                completion(true)
//                #warning("notify other user they have a connection request")
//            }
//        }
//    }
//
//    func friendRequestAction(fromUser uuid: String, accept: Bool, completion: @escaping (Bool) -> Void) {
//        guard let currentUser = currentUser else { completion(false) ; return }
//        let currentUserID = currentUser.uuid
//
//        if accept {
//            //add my uid to other person's connectionID array
//            Firestore.firestore().collection("users").document(uuid).updateData(["connectionIDs" : FieldValue.arrayUnion([currentUserID])]) { error in
//                if let error = error {
//                    print(error.localizedDescription)
//                    completion(false)
//                    return
//                } else {
//                    //remove uid from my inviteIDs array, add to my connectionID array
//                    Firestore.firestore().collection("users").document(currentUserID).updateData(["connectionIDs" : FieldValue.arrayUnion([uuid]), "connectionInviteIDs" : FieldValue.arrayRemove([uuid])]) { error in
//                        if let error = error {
//                            print(error.localizedDescription)
//                            completion(false)
//                            return
//                        } else {
//                            currentUser.connectionIDs?.append(uuid)
//                            UserController.shared.changeUserInfo(user: currentUser, completion: { (_) in
//
//                            })
//                            completion(true)
//                            // Notify other person that I accepted???
//                        }
//                    }
//                }
//            }
//        } else {
//            //remove the connectionInvite
//            Firestore.firestore().collection("users").document(currentUserID).updateData(["connectionInviteIDs" : FieldValue.arrayRemove([uuid])]) { error in
//                if let error = error {
//                    print(error.localizedDescription)
//                    completion(false)
//                    return
//                } else {
//                    completion(true)
//                }
//            }
//        }
//    }
    
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
