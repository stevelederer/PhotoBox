//
//  BasicEvent.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/18/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class BasicEvent: FirestoreFetchable {
    
    static let CollectionName: String = "basicEvent"
    
    let uuid: String
    var eventName: String
    var coverPhotoURL: String?
    var endTime: TimeInterval
    var formattedEndTime: String? {
        let date = Date(timeIntervalSince1970: endTime)
        return date.formattedString()
    }
    
    init(uuid: String, eventName: String, coverPhotoURL: String?, endTime: TimeInterval) {
        self.uuid = uuid
        self.eventName = eventName
        self.coverPhotoURL = coverPhotoURL
        self.endTime = endTime
    }
    
    required convenience init?(with dictionary: [String : Any], id: String) {
        guard let eventName = dictionary["eventName"] as? String,
            let coverPhotoURL = dictionary["coverPhotoURL"] as? String?,
            let endTime = dictionary["endTime"] as? TimeInterval else {return nil}
        self.init(uuid: id, eventName: eventName, coverPhotoURL: coverPhotoURL, endTime : endTime)
    }
}

extension BasicEvent {
    
    var dictionary: [String : Any?] {
        return [
            "uuid" : uuid,
            "eventName" : eventName,
            "coverPhotoURL" : coverPhotoURL,
            "endTime" : endTime
        ]
    }
}
