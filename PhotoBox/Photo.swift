//
//  Photo.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/18/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class Photo: FirestoreFetchable {
    
    static var CollectionName: String = "photo"
    
    let uuid: String
    let imageURL: String
    let eventID: String
    let user: String
    
    init(uuid: String, imageURL: String, eventID: String, user: String) {
        self.uuid = uuid
        self.imageURL = imageURL
        self.eventID = eventID
        self.user = user
    }
    
    convenience required init?(with dictionary: [String : Any], id: String) {
        guard let imageURL = dictionary["imageURL"] as? String,
        let eventID = dictionary["eventID"] as? String,
        let user = dictionary["user"] as? String  else {return nil}
        
        self.init(uuid: id, imageURL: imageURL, eventID: eventID, user: user)
    }
}

extension Photo {
    var dictionary: [String : Any?] {
        return [
            "uuid" : uuid,
            "imageURL" : imageURL,
            "eventID" : eventID,
            "user" : user
        ]
    }
}
