//
//  EventController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/21/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class EventController {
    
     //   MARK: - Share Instance
    
    static let shared = EventController()
    private init(){}
    
     //   MARK: - Source of truth
    var event: Event?
        
//   MARK: - Functions
    
   
    // Create an event
    func createAnEvent(eventName: String, admins: [BasicProfile], adminsIDs: [String], members: [BasicProfile], membersIDs: [String], status: String, startTime: TimeInterval, endTime: TimeInterval, details: String?, location: String?, coverPhoto: UIImage?, completion: @escaping (Bool) -> Void) {
        
        let newEvent = Event(eventName: eventName, admins: admins, adminIDs: adminsIDs, members: members, memberIDs: membersIDs, status: status, startTime: startTime, endTime: endTime, details: details, location: location, coverPhoto: coverPhoto)
        
        FirebaseManager.saveData(object: newEvent) { (success) in
            if !(success != nil) {
                print("There was an error creating event \(newEvent)")
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    
    // Update an event
    func updateAnEvent(event: Event, eventName: String, admins: [BasicProfile], photos: [Photo]?, members: [BasicProfile], endTime: TimeInterval, details: String?, location: String, coverPhoto: UIImage?, completion: @escaping (Bool) -> Void) {
        
        event.eventName = eventName
        event.admins = admins
        event.photos = photos
        event.members = members
        event.endTime = endTime
        event.details = details
        event.location = location
        event.coverPhoto = coverPhoto
        
        FirebaseManager.updateData(obect: event, dictionary: event.dictionary) { (success) in
            if !(success != nil) {
                print("There was an error updating event \(event)")
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
    
    func uploadPhotos(photos: Photo, completion: @escaping (Bool) -> Void) {
    }
    
    func addInvites(with members: [BasicProfile], completion: @escaping (Bool) -> Void) {
        
    }
}
