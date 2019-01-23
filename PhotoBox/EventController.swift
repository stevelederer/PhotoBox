//
//  EventController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/21/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit
import FirebaseFirestore

class EventController {
    
    //   MARK: - Share Instance
    
    static let shared = EventController()
    private init(){}
    
    //   MARK: - Source of truth
    
    var currentEvent: Event?
    
    //   MARK: - Functions
    
    
    // Create an event
    func createAnEvent(eventName: String, creatorID: String, memberIDs: [String], startTime: TimeInterval, endTime: TimeInterval, details: String?, location: String?, coverPhoto: UIImage?, completion: @escaping (Bool) -> Void) {
        
        let newEvent = Event(eventName: eventName, creatorID: creatorID, memberIDs: memberIDs, startTime: startTime, endTime: endTime, details: details, location: location, coverPhoto: coverPhoto)
        
        FirebaseManager.saveData(object: newEvent) { (error) in
            if let error = error {
                print("There was an error creating event \(newEvent). \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    
    // Update an event
    func updateAnEvent(event: Event, eventName: String, memberIDs: [String], startTime: TimeInterval, endTime: TimeInterval, details: String?, location: String?, coverPhoto: UIImage?, completion: @escaping (Bool) -> Void) {
        
        event.eventName = eventName
        event.memberIDs = memberIDs
        event.startTime = startTime
        event.endTime = endTime
        event.details = details
        event.location = location
        event.coverPhoto = coverPhoto
        
        FirebaseManager.updateData(obect: event, dictionary: event.dictionary) { (error) in
            if let error = error {
                print("There was an error updating event \(event). \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    
    // Delete an Event
    func deleteAnEvent(event: Event, completion: @escaping (Bool) -> Void) {
        FirebaseManager.deleteData(object: event) { (success) in
            if !success {
                print("There was an error deleting an event \(event)")
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    //Upload photos to an event
    
    func uploadPhotos(photos: Photo, completion: @escaping (Bool) -> Void) {
        FirebaseManager.saveData(object: photos) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    //Delete photos from an event
    
    func deletePhotos(photos: Photo, completion: @escaping (Bool) -> Void) {
        FirebaseManager.deleteData(object: photos) { (success) in
            if !success {
                print("There was an error deleting a photo \(photos)")
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    // Add people to event
    
    func addInvites(username: String, eventID: String, completion: @escaping (Bool) -> Void) {
        
        FirebaseManager.fetchFirestoreWithFieldAndCriteria(for: "username", criteria: username) { (basicProfile: [BasicProfile]?) in
            guard let basicProfile = basicProfile?.first else { completion(false) ; return }
            
            FirebaseManager.updateData(obect: basicProfile, dictionary: ["inviteEventIDs" : eventID], completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                
                completion(true)
            })
            
        }
        
    }
    
    //remove a user from an event
    
    func removeUser(from event: Event, uuid: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("events").document(event.uuid).updateData(["memberIDs" : FieldValue.arrayRemove([uuid])]) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
        }
    }
    // admin can edit people in event
    
    func adminEditAttendees() {
        
    }
}

