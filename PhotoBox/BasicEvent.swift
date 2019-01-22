//
//  BasicEvent.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/18/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class BasicEvent: FirestoreFetchable {
    
    static let CollectionName: String = "basicEvent"
    
    let uuid: String
    var eventName: String
    var coverPhotoURL: String?
    
    init(uuid: String, eventName: String, coverPhotoURL: String?) {
        self.uuid = uuid
        self.eventName = eventName
        self.coverPhotoURL = coverPhotoURL
    }
    
    required convenience init?(with dictionary: [String : Any], id: String) {
        guard let eventName = dictionary["eventName"] as? String,
            let coverPhotoURL = dictionary["coverPhotoURL"] as? String? else {return nil}
        self.init(uuid: id, eventName: eventName, coverPhotoURL: coverPhotoURL)
    }
}

extension BasicEvent {
    
    var dictionary: [String : Any?] {
        return [
            "uuid" : uuid,
            "eventName" : eventName,
            "coverPhotoURL" : coverPhotoURL
        ]
    }
}
