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
    var photos: [UIImage]
    var owner: [User]
    var members: [User]
    var status: String //is this a string??
    var time: DateInterval
    var details: String //use a textview and should this be optional?
    var location: String //should this be optional?
    
    init(uuid: String = UUID().uuidString, photos: [UIImage], owner: [User], members: [User], status: String, time: DateInterval, details: String, location: String) {
        self.uuid = uuid
        self.photos = photos
        self.owner = owner
        self.members = members
        self.status = status
        self.time = time
        self.details = details
        self.location = location
        
    }
    
    required convenience init?(with dictionary: [String : Any], id: String) {
        guard let photos = dictionary["photos"] as? UIImage,
        let owner = dictionary["owner"] as? [User],
        let members = dictionary["members"] as? [User],
        let status = dictionary["status"] as? String,
        let time = dictionary["time"] as? DateInterval,
        let details = dictionary["details"] as? String,
        let location = dictionary["location"] as? String else {return nil}
        
        self.init(uuid: id, photos: [photos], owner: owner, members: members, status: status, time: time, details: details, location: location)
    }
}

extension Event {
    
    var dictionary: [String : Any] {
        return [
            "uuid" : uuid,
            "photos" : photos,
            "owner" : owner,
            "members" : members,
            "status" : status,
            "time" : time,
            "details" : details,
            "location" : location]
    }

}
