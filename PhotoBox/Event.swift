//
//  Event.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class Event: FirestoreFetchable {
    
    static let CollectionName: String = "events"
    
    let uuid: String
    var eventName: String
    let eventCode: String
    let creatorID: String
    var memberIDs: [String]
    var startTime: TimeInterval
    var endTime: TimeInterval
    var details: String?
    var location: String?
    var photoIDs: [String]?
    var coverPhoto: UIImage?
    var coverPhotoURL: String?
    var formattedStartTime: String {
        let date = Date(timeIntervalSince1970: startTime)
        return date.formattedString()
    }
    var formattedEndTime: String? {
        let date = Date(timeIntervalSince1970: endTime)
        return date.formattedString()
    }
    
    init(uuid: String = UUID().uuidString, eventName: String, eventCode: String, creatorID: String, memberIDs: [String], startTime: TimeInterval, endTime: TimeInterval, details: String? = nil, location: String? = nil, photoIDs: [String]? = nil, coverPhoto: UIImage? = nil, coverPhotoURL: String? = nil) {
        self.uuid = uuid
        self.eventName = eventName
        self.eventCode = eventCode
        self.creatorID = creatorID
        self.memberIDs = memberIDs
        self.startTime = startTime
        self.endTime = endTime
        self.details = details
        self.location = location
        self.photoIDs = photoIDs
        self.coverPhoto = coverPhoto
        self.coverPhotoURL = coverPhotoURL
    }
    
    required init?(with dictionary: [String : Any], id: String) {
        guard let eventName = dictionary["eventName"] as? String,
            let eventCode = dictionary["eventCode"] as? String,
            let creatorID = dictionary["creatorID"] as? String,
            let memberIDs = dictionary["memberIDs"] as? [String],
            let startTime = dictionary["startTime"] as? TimeInterval,
            let endTime = dictionary["endTime"] as? TimeInterval
            else {return nil}
        
        self.uuid = id
        self.eventName = eventName
        self.eventCode = eventCode
        self.creatorID = creatorID
        self.memberIDs = memberIDs
        self.startTime = startTime
        self.endTime = endTime
        
        if let details = dictionary["details"] as? String? {
            self.details = details
        }
        if let location = dictionary["locations"] as? String? {
            self.location = location
        }
        if let photoIDs = dictionary["photoIDs"] as? [String]? {
            self.photoIDs = photoIDs
        }
        if let coverPhotoURL = dictionary["coverPhotoURL"] as? String? {
            self.coverPhotoURL = coverPhotoURL
        }
    }
}

extension Event {
    
    var dictionary: [String : Any?] { //should any be optional
        return [
            "uuid" : uuid,
            "eventName" : eventName,
            "eventCode" : eventCode,
            "creatorID" : creatorID,
            "memberIDs" : memberIDs,
            "startTime" : startTime,
            "endTime" : endTime,
            "details" : details,
            "location" : location,
            "photoIDs" : photoIDs,
            "coverPhotoURL" : coverPhotoURL
        ]
    }

}
