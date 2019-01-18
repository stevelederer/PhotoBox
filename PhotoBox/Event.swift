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
    let eventName: String
    var photos: [Photo]
    var admins: [BasicProfile]
    var members: [BasicProfile] // is this right?
    var status: String //is this a string??
    var time: DateInterval
    var details: String //use a textview and should this be optional?
    var location: String //should this be optional?
    var coverPhoto: UIImage?
    
    init(uuid: String = UUID().uuidString, eventName: String, photos: [Photo], admins: [BasicProfile], members: [BasicProfile], status: String, time: DateInterval, details: String, location: String, coverPhoto: UIImage) {
        self.uuid = uuid
        self.eventName = eventName
        self.photos = photos
        self.admins = admins
        self.members = members
        self.status = status
        self.time = time
        self.details = details
        self.location = location
        self.coverPhoto = coverPhoto
    }
    
    required convenience init?(with dictionary: [String : Any], id: String) {
        guard let eventName = dictionary["eventName"] as? String,
        let photos = dictionary["photos"] as? [Photo],
        let admins = dictionary["admins"] as? [BasicProfile],
        let members = dictionary["members"] as? [BasicProfile],
        let status = dictionary["status"] as? String,
        let time = dictionary["time"] as? DateInterval,
        let details = dictionary["details"] as? String,
        let location = dictionary["location"] as? String,
        let coverPhoto = dictionary["coverPhoto"] as? UIImage else {return nil}
        
        self.init(uuid: id, eventName: eventName, photos: photos, admins: admins, members: members, status: status, time: time, details: details, location: location, coverPhoto: coverPhoto)
    }
}

extension Event {
    
    var dictionary: [String : Any] {
        return [
            "uuid" : uuid,
            "eventName" : eventName,
            "photos" : photos,
            "admins" : admins,
            "members" : members,
            "status" : status,
            "time" : time,
            "details" : details,
            "location" : location,
            "coverPhoto" : coverPhoto]
    }

}
