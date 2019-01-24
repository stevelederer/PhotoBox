//
//  BasicEventController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/23/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation

class BasicEventController {
    
    //   MARK: - Shared Instance
    
    static let shared = BasicEventController()
    private init() {}
    
    func createBasicEvent(from event: Event, completion: @escaping (Bool) -> Void) {
        
        let newBasicEvent = BasicEvent(uuid: event.uuid, eventName: event.eventName, coverPhotoURL: event.coverPhotoURL, endTime: event.endTime)
        
        FirebaseManager.saveData(object: newBasicEvent) { (error) in
            if let error = error {
                print("There was an error saving basic profile for \(newBasicEvent): \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
            return
        }
    }
    
    func changeBasicEvent(event: Event, completion: @escaping (Bool) -> Void) {
        
        let updatedBasicEvent = BasicEvent(uuid: event.uuid, eventName: event.eventName, coverPhotoURL: event.coverPhotoURL, endTime: event.endTime)
        
        
        FirebaseManager.updateData(obect: updatedBasicEvent, dictionary: updatedBasicEvent.dictionary) { (error) in
            if let error = error {
                print("There was an error updating profile information for \(updatedBasicEvent.eventName): \(error) ; \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
            return
        }
    }
}


