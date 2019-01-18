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
    let eventName: String
    let coverPhoto: UIImage?
    
    init(uuid: String, eventName: String, coverPhoto: UIImage) {
        self.uuid = uuid
        self.eventName = eventName
        self.coverPhoto = coverPhoto
    }
    
    required convenience init?(with dictionary: [String : Any], id: String) {
        guard let eventName = dictionary["eventName"] as? String,
            let coverPhoto = dictionary["coverPhoto"] as? UIImage else {return nil}
        self.init(uuid: id, eventName: eventName, coverPhoto: coverPhoto)
    }
}

extension BasicEvent {
    
    var dictionary: [String : Any] {
        return [
            "uuid" : uuid,
            "eventName" : eventName,
            "coverPhoto" : coverPhoto
        ]
    }
}
