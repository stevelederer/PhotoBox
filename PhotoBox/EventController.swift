//
//  EventController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/21/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit
import FirebaseFirestore

class EventController {
    
    //   MARK: - Share Instance
    
    static let shared = EventController()
    private init(){}
    
    //   MARK: - Source of truth
    
    var currentEvent: Event?
    var currentEventMembers: [BasicProfile] = []
    
    //   MARK: - Functions
    
    
    // Create an event
    func createAnEvent(eventName: String, creatorID: String, memberIDs: [String], startTime: TimeInterval, endTime: TimeInterval, details: String?, location: String?, completion: @escaping (Event?) -> Void) {
        
        var newEventCode: String = ""
        randomEventCode { (newCode) in
            guard let newCode = newCode else { return }
            newEventCode = newCode
        }
        
        let newEvent = Event(eventName: eventName, eventCode: newEventCode, creatorID: creatorID, memberIDs: memberIDs, startTime: startTime, endTime: endTime, details: details, location: location)
        
        FirebaseManager.saveData(object: newEvent) { (error) in
            if let error = error {
                print("There was an error creating event \(newEvent). \(error.localizedDescription)")
                completion(nil)
                return
            } else {
                BasicEventController.shared.createBasicEvent(from: newEvent, completion: { (success) in
                    completion(newEvent)
                })
            }
        }
    }
    
    func randomEventCode(completion: @escaping (String?) -> Void) {
        let characters = "ABCDEFGHIJKLMNPQRSTUVWXYZ123456789"
        let newCode = String((0...3).map{ _ in characters.randomElement()! })
        var returnedEvents: [Event] = []
        
        let eventsRef = Firestore.firestore().collection("events")
        eventsRef.whereField("eventCode", isEqualTo: newCode).getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                guard let documents = querySnapshot?.documents else { return }
                for event in documents {
                    let eventDictionary = event.data()
                    guard let newEvent = Event(with: eventDictionary, id: event.documentID) else { return }
                    returnedEvents.append(newEvent)
                }
            }
        }
        if returnedEvents.isEmpty {
            completion(newCode)
        } else {
            randomEventCode(completion: completion)
        }
    }
    
    // Update an event
    func updateAnEvent(event: Event, eventName: String, memberIDs: [String], startTime: TimeInterval, endTime: TimeInterval, details: String?, location: String?, completion: @escaping (Bool) -> Void) {
        
        event.eventName = eventName
        event.memberIDs = memberIDs
        event.startTime = startTime
        event.endTime = endTime
        event.details = details
        event.location = location
        
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
    
    func leaveEvent() {
        
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
        
        FirebaseManager.fetchFirestoreWithFieldAndCriteria(for: "username", criteria: username, inArray: false) { (basicProfile: [BasicProfile]?) in
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
        #warning("remove attendees")
    }
    
    func fetchEvents(completion: @escaping (Bool, [BasicEvent]?) -> Void) {
        
        guard let currentUser = UserController.shared.currentUser else { completion(false, nil) ; return }
        
        FirebaseManager.fetchFirestoreWithFieldAndCriteria(for: "memberIDs", criteria: currentUser.uuid, inArray: true) { (events: [BasicEvent]?) in
            if let events = events {
                completion(true, events)
                return
            } else {
                completion(false, nil)
                return
            }
        }
    }
    
    func fetchMembers(for event: Event, completion: @escaping ([AppUser]?) -> Void) {
        
        FirebaseManager.fetchFirestoreWithFieldAndCriteria(for: "eventIDs", criteria: event.uuid, inArray: true) { (users: [AppUser]?) in
            guard let users = users else { completion(nil) ; return }
            
            completion(users)
        }
    }
}

