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
    
    var uuid: String
    let imageURL: String
    let numberOfLikes: Int
    
    init(uuid: String, imageURL: String, numberOfLikes: Int = 0) {
        self.uuid = uuid
        self.imageURL = imageURL
        self.numberOfLikes = numberOfLikes
    }
    
    convenience required init?(with dictionary: [String : Any], id: String) {
        guard let imageURL = dictionary["imageURL"] as? String,
            let numberOfLikes = dictionary["numberOfLikes"] as? Int else {return nil}
        
        self.init(uuid: id, imageURL: imageURL, numberOfLikes: numberOfLikes)
    }
}
extension Photo {
    
    var dictionary: [String : Any?] {
        return [
            "uuid" : uuid,
            "imageURL" : imageURL,
            "numberOfLikes" : numberOfLikes
        ]
    }
}
