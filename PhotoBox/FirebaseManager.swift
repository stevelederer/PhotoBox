//
//  FirebaseManager.swift
//  BatchShare
//
//  Created by Steve Lederer on 1/15/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FirebaseManager {
    
    // MARK: - User Functions
    
    static func signUp(name: String, email: String, username: String, password: String, completion: @escaping (AppUser?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("There was an error creating user with email address \(email)...\(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let user = authResult?.user else {
                print("Error unwrapping user.")
                return
            }
            
            let uuid = user.uid
            
            let newUser = AppUser(uuid: uuid, name: name, username: username, emailAddress: email)
            
            self.saveData(object: newUser, completion: { (error) in
                if let error = error {
                    print("Error saving user to FireStore: \(error); \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }
            })
            completion(newUser, nil)
            return
        }
    }
    
    static func logInWith(email: String, password: String, completion: @escaping (AppUser?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("There was an error signing in user with email addresss \(email). \(error) ; \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let user = authResult?.user else {
                print("error unwrapping user.")
                return
            }
            
            let uuid = user.uid
            
            let collectionReference = Firestore.firestore().collection("users")
            
            collectionReference.document(uuid).getDocument(completion: { (fetchedUserSnapshot, error) in
                if let error = error {
                    print("There was an error in \(#function): \(error) ; \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }
                guard let fetchedUserData = fetchedUserSnapshot, fetchedUserData.exists, let fetchedUserDictionary = fetchedUserData.data() else { completion(nil, nil) ; return }

                let signedInuser = AppUser(with: fetchedUserDictionary, id: fetchedUserData.documentID)
                completion(signedInuser, nil)
            })
            
        }
    }
    
    static func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            print("There was an error signing out. \(error) ; \(error.localizedDescription)")
            completion(error)
        }
    }
    
    static func getLoggedInUser(completion: @escaping (AppUser?) -> Void)  {
        if Auth.auth().currentUser != nil {
            guard let user = Auth.auth().currentUser else { return }
            
            let uuid = user.uid
            
            let collectionReference = Firestore.firestore().collection("users")
            collectionReference.document(uuid).getDocument { (fetchedUserSnapshot, error) in
                if let error = error {
                    print("There was an error in \(#function): \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                guard let fetchedUserData = fetchedUserSnapshot, fetchedUserData.exists, let fetchedUserDictionary = fetchedUserData.data() else { completion(nil) ; return }
                
                let loggedInUser = AppUser(with: fetchedUserDictionary, id: uuid)
                completion(loggedInUser)
            }
        } else {
            print("No user is currently signed in.")
            completion(nil)
            return
        }
    }
    
    static func deleteLoggedInUser(completion: @escaping (Bool) -> Void) {
        if Auth.auth().currentUser != nil {
            guard let user = Auth.auth().currentUser else { return }
            
            let userID = user.uid
            
            let usersCollectionReference = Firestore.firestore().collection("users")
            
            usersCollectionReference.document(userID).delete { (error) in
                if let error = error {
                    print("Error deleting user from \"users\" database \(error.localizedDescription)")
                } else {
                    print("User deleted!")
                }
            }
            
            let basicProfileCollectionReference = Firestore.firestore().collection("BasicProfile")
            
            basicProfileCollectionReference.document(userID).delete { (error) in
                if let error = error {
                    print("Error deleting basic profile from \"basic profile\" database. \(error.localizedDescription)")
                } else {
                    print("Basic profile deleted!")
                }
            }
            
            #warning("remember to delete photos posted by the user")
            
            user.delete { (error) in
                if let error = error {
                    print("Error deleting account: \(error.localizedDescription)")
                } else {
                    print("␡␡␡ⓧ Account Deleted ⓧ␡␡␡")
                    completion(true)
                }
            }
        }
    }
    
    static func forgotPassword(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("There was an error sending password reset to \(email). \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
                return
            }
        }
    }
    
    // MARK: - Fetch Functions
        
    static func fetchFromFirestore<T: FirestoreFetchable>(uuid: String, completion: @escaping (T?) -> Void) {
        let collectionReference = T.collection
    
        collectionReference.document(uuid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("There was an error in \(#function) \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let documentSnapshot = documentSnapshot, documentSnapshot.exists, let objectDictionary = documentSnapshot.data() else { completion(nil) ; return }
            
            let object = T(with: objectDictionary, id: documentSnapshot.documentID)
            completion(object)
        }
    }

    static func fetchAllInACollectionFromFirestore<T: FirestoreFetchable>(completion: @escaping ([T]?) -> Void) {
        let collectionReference = T.collection
        
        collectionReference.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("There was an error in \(#function) \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let documents = querySnapshot?.documents else { completion(nil) ; return }
            let dictionaries = documents.compactMap{ $0.data() }
            var returnValue: [T] = []
            for dictionary in dictionaries {
                guard let uuid = dictionary["uuid"] as? String,
                    let object = T(with: dictionary, id: uuid) else { completion(nil) ; return }
                returnValue.append(object)
            }
            completion(returnValue)
        }
    }
    

    static func fetchFirestoreWithFieldAndCriteria<T: FirestoreFetchable>(for field: String, criteria: String, inArray: Bool, completion: @escaping ([T]?) -> Void) {
        let collectionReference = T.collection
        var filteredCollection: Query?
        if inArray {
            filteredCollection = collectionReference.whereField(field, arrayContains: criteria)
        } else {
            filteredCollection = collectionReference.whereField(field, isEqualTo: criteria)
        
        }
        
        filteredCollection?.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("There was an error in\(#function) \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let documents = querySnapshot?.documents else { completion(nil) ; return }
            let dictionaries = documents.compactMap{ $0.data() }
            var returnValue: [T] = []
            for dictionary in dictionaries {
                guard let uuid = dictionary["uuid"] as? String,
                    let object = T(with: dictionary, id: uuid) else { print("🚨🚨🚨 problem on firebasemanager line 187") ; completion(nil) ; return }
                returnValue.append(object)
            }
            completion(returnValue)
        }
    }
    
    static func fetchBasicEvent(for uuid: String, completion: @escaping (BasicEvent?) -> Void) {
        let collectionReference = Firestore.firestore().collection("basicEvent")
        collectionReference.document(uuid).getDocument { (basicEventSnapshot, error) in
            if let error = error {
                print("Thre was an error in \(#function): \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let basicEventSnapshot = basicEventSnapshot, basicEventSnapshot.exists, let basicEventDictionary = basicEventSnapshot.data() else { completion(nil) ; return }
            
            let basicEvent = BasicEvent(with: basicEventDictionary, id: uuid)
            completion(basicEvent)
        }
    }
    
    // MARK: - Create, Update, Delete
    
    static func saveData<T: FirestoreFetchable>(object: T, completion: @escaping (Error?) -> Void) {
        let collectionReference = T.collection
        let documentReference = collectionReference.document(object.uuid)
        documentReference.setData(object.dictionary) { (error) in
            if let error = error {
                print("Error! \(error) \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    static func updateData<T: FirestoreFetchable>(obect: T, dictionary: [String : Any], completion: @escaping (Error?) -> Void) {
        let documentReference = T.collection.document(obect.uuid)
        documentReference.updateData(dictionary) { (error) in
            if let error = error {
                print("There was an error in \(#function) ---- \(error) \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }
        
    }
    
    static func deleteData<T: FirestoreFetchable>(object: T, withChildren children: [String]? = nil, completion: @escaping (Bool) -> Void) {
        let collectionReference = T.collection
        
        collectionReference.document(object.uuid).delete { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // MARK: - Photo Storage
    
    
    static func uploadPhotoToFirebase<T: FirebaseStorable>(_ object: T, completion: @escaping (URL?, Error?) -> Void) {
        let storageRef = object.storageReference
        let objectRef = storageRef.child("\(object.uuid).jpg")
        let _ = objectRef.putData(object.data, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                completion(nil, nil)
                return
            }
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
            
            objectRef.downloadURL(completion: { (url, _) in
                guard let downloadURL = url else { return }
                print(downloadURL)
                completion(downloadURL, nil)
            })
        }
    }
    
    
    static func fetchPhotoFromFirebase(url: String, completion: @escaping (Bool, UIImage?) -> Void) {
        let storage = Storage.storage()
        let pathReference = storage.reference(forURL: url)
        
        pathReference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, nil)
            } else {
                guard let data = data else { return }
                let image = UIImage(data: data)
                completion(true, image)
            }
        }
    }
}
