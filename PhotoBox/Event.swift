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
    var photos: [Photo]?
    var photoIDs : [String]?
    var admins: [BasicProfile]
    var adminIDs: [String]
    var members: [BasicProfile]
    var memberIDs: [String]
    var status: String
    var startTime: TimeInterval
    var endTime: TimeInterval
    var details: String?
    var location: String?
    var coverPhoto: UIImage?
    var coverPhotoURL: String?
    
    init(uuid: String = UUID().uuidString, eventName: String, photos: [Photo]? = nil, photoIDs: [String]? = nil, admins: [BasicProfile], adminIDs: [String], members: [BasicProfile], memberIDs: [String], status: String, startTime: TimeInterval, endTime: TimeInterval, details: String? = nil, location: String? = nil, coverPhoto: UIImage? = nil, coverPhotoURL: String? = nil) {
        self.uuid = uuid
        self.eventName = eventName
        self.photos = photos
        self.photoIDs = photoIDs
        self.admins = admins
        self.adminIDs = adminIDs
        self.members = members
        self.memberIDs = memberIDs
        self.status = status
        self.startTime = startTime
        self.endTime = endTime
        self.details = details
        self.location = location
        self.coverPhoto = coverPhoto
        self.coverPhotoURL = coverPhotoURL
    }
    
    required convenience init?(with dictionary: [String : Any], id: String) {
        guard let eventName = dictionary["eventName"] as? String,
        let photos = dictionary["photos"] as? [Photo]?,
        let photoIDs = dictionary["photo"] as? [String]?,
        let admins = dictionary["admins"] as? [BasicProfile],
        let adminIDs = dictionary["adminIDs"] as? [String],
        let members = dictionary["members"] as? [BasicProfile],
        let memberIDs = dictionary["memberIDs"] as? [String],
        let status = dictionary["status"] as? String,
        let startTime = dictionary["startTime"] as? TimeInterval,
        let endTime = dictionary["endTime"] as? TimeInterval,
        let details = dictionary["details"] as? String?,
        let location = dictionary["location"] as? String?,
        let coverPhoto = dictionary["coverPhoto"] as? UIImage?,
        let coverPhotoURL = dictionary["coverPhotoURL"] as? String? else {return nil}
        
        self.init(uuid: id, eventName: eventName, photos: photos, photoIDs: photoIDs, admins: admins, adminIDs:adminIDs, members: members, memberIDs: memberIDs,  status: status, startTime: startTime, endTime: endTime, details: details, location: location, coverPhoto: coverPhoto, coverPhotoURL: coverPhotoURL)
    }
}

extension Event {
    
    var dictionary: [String : Any?] { //should any be optional
        return [
            "uuid" : uuid,
            "eventName" : eventName,
            "photos" : photos,
            "photoIDs" : photoIDs,
            "admins" : admins,
            "adminIDs" : adminIDs,
            "members" : members,
            "memberIDs" : memberIDs,
            "status" : status,
            "startTime" : startTime,
            "endTime" : endTime,
            "details" : details,
            "location" : location,
            "coverPhoto" : coverPhoto,
            "coverPhotoURL" : coverPhotoURL
        ]
    }

}
