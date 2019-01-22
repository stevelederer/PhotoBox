//
//  User.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class AppUser: FirestoreFetchable {
    
    static let CollectionName: String = "users"
    
    let uuid: String
    var name: String
    var username: String
    var emailAddress: String
    var profilePic: UIImage?
    var profilePicURL: String?
    var blockedUserIDs: [String]?
    
    init(uuid: String = UUID().uuidString, name: String, username: String, emailAddress: String, profilePicURL: String? = nil, blockedUserIDs: [String]? = nil) {
        
        self.uuid = uuid
        self.name = name
        self.username = username
        self.emailAddress = emailAddress
        self.profilePicURL = profilePicURL
        self.blockedUserIDs = blockedUserIDs
    }
    
    required init?(with dictionary: [String : Any], id: String) {
        guard let name = dictionary["name"] as? String,
            let username = dictionary["username"] as? String,
            let emailAddress = dictionary["emailAddress"] as? String
            else {return nil}
        
        self.uuid = id
        self.name = name
        self.username = username
        self.emailAddress = emailAddress
        
        if let profilePicURL = dictionary["profilePicURL"] as? String? {
            self.profilePicURL = profilePicURL
        }
        if let blockedUserIDs = dictionary["blockedUserIDs"] as? [String]? {
            self.blockedUserIDs = blockedUserIDs
        }
    }
}

extension AppUser { // should any be optional??
    var dictionary: [String : Any?] {
        return [
            "uuid": uuid,
            "name": name,
            "username": username,
            "emailAddress": emailAddress,
            "profilePicURL" : profilePicURL,
            "blockedUsersIDs" : blockedUserIDs
        ]
    }
}
