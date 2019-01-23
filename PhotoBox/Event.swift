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
    var coverPhoto: UIImage?
    var coverPhotoURL: String?
    
    init(uuid: String = UUID().uuidString, eventName: String, eventCode: String, creatorID: String, memberIDs: [String], startTime: TimeInterval, endTime: TimeInterval, details: String? = nil, location: String? = nil, coverPhoto: UIImage? = nil, coverPhotoURL: String? = nil) {
        self.uuid = uuid
        self.eventName = eventName
        self.eventCode = eventCode
        self.creatorID = creatorID
        self.memberIDs = memberIDs
        self.startTime = startTime
        self.endTime = endTime
        self.details = details
        self.location = location
        self.coverPhoto = coverPhoto
        self.coverPhotoURL = coverPhotoURL
    }
    
    required convenience init?(with dictionary: [String : Any], id: String) {
        guard let eventName = dictionary["eventName"] as? String,
            let eventCode = dictionary["eventCode"] as? String,
            let creatorID = dictionary["creatorID"] as? String,
            let memberIDs = dictionary["memberIDs"] as? [String],
            let startTime = dictionary["startTime"] as? TimeInterval,
            let endTime = dictionary["endTime"] as? TimeInterval,
            let details = dictionary["details"] as? String?,
            let location = dictionary["location"] as? String?,
            let coverPhoto = dictionary["coverPhoto"] as? UIImage?,
            let coverPhotoURL = dictionary["coverPhotoURL"] as? String? else {return nil}
        
        self.init(uuid: id, eventName: eventName, eventCode: eventCode, creatorID: creatorID, memberIDs: memberIDs, startTime: startTime, endTime: endTime, details: details, location: location, coverPhoto: coverPhoto, coverPhotoURL: coverPhotoURL)
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
            "coverPhoto" : coverPhoto,
            "coverPhotoURL" : coverPhotoURL
        ]
    }

}
