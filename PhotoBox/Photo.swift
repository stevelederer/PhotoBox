//
//  Photo.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/18/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class Photo: FirestoreFetchable, FirebaseStorable, Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    
    static var CollectionName: String = "photos"
    
    var image: UIImage?
    let uuid: String
    let eventID: String
    var imageURL: String?
    let creatorID: String
    var data: Data {
        guard let image = self.image,
            let data = image.jpegData(compressionQuality: 0.25)
            else { return Data() }
        return data
    }
    var isSelected = true
    
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
