//
//  BasicProfile.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/18/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class BasicProfile: FirestoreFetchable {
    
    static let CollectionName: String = "BasicProfile"
    
    let uuid: String
    var username: String
    var name: String
    var profilePicURL: String?
    
    init(uuid: String, username: String, name: String, profilePicURL: String? = nil) {
        self.uuid = uuid
        self.username = username
        self.name = name
        self.profilePicURL = profilePicURL
    }
    
    convenience required init?(with dictionary: [String : Any], id: String) {
        guard let name = dictionary["name"] as? String,
            let username = dictionary["username"] as? String,
            let profilePicURL = dictionary["profilePicURL"] as? String? else {return nil}
        
        self.init(uuid: id, username: username, name: name, profilePicURL: profilePicURL)
    }
}

extension BasicProfile {
    
    var dictionary: [String : Any?] {
        return [
            "uuid" : uuid,
            "username" : username,
            "name" : name,
            "profilePicURL" : profilePicURL
        ]
        
    }

}
