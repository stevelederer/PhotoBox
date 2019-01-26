//
//  Photo.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/18/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class Photo: FirestoreFetchable, FirebaseStorable {
    
    static var CollectionName: String = "photo"
    
    let image: UIImage?
    let uuid: String
    let eventID: String
    let imageURL: String?
    let creatorID: String
    var data: Data {
        guard let image = self.image,
            let data = image.jpegData(compressionQuality: 0.25)
            else { return Data() }
        return data
    }
    
    init(image: UIImage?, uuid: String = UUID().uuidString, eventID: String, creatorID: String) {
        self.image = image
        self.uuid = uuid
        self.eventID = eventID
        self.creatorID = creatorID
        self.imageURL = nil
    }
    
    required init?(with dictionary: [String : Any], id: String) {
        guard let imageURL = dictionary["imageURL"] as? String,
            let uuid = dictionary["uuid"] as? String,
            let eventID = dictionary["eventID"] as? String,
            let creatorID = dictionary["creatorID"] as? String
            else {return nil}
        
        self.image = nil
        self.imageURL = imageURL
        self.uuid = uuid
        self.eventID = eventID
        self.creatorID = creatorID
    }
}

extension Photo {
    var dictionary: [String : Any?] {
        return [
            "uuid" : uuid,
            "imageURL" : imageURL,
            "eventID" : eventID,
            "creatorID" : creatorID
        ]
    }
}
