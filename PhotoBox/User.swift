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
    var memberEventIDs: [String]?
    var creatorEventIDs: [String]?
    var inviteEventIDs: [String]?
    var connectionIDs: [String]?
    var connectionInviteIDs: [String]?
    var groups: [Groups]?
    var blockedUserIDs: [String]?
    
    init(uuid: String = UUID().uuidString, name: String, username: String, emailAddress: String) {
        
        self.uuid = uuid
        self.name = name
        self.username = username
        self.emailAddress = emailAddress
    }
    
    convenience required init?(with dictionary: [String : Any], id: String) {
        
        guard let name = dictionary["name"] as? String,
        let username = dictionary["username"] as? String,
        let emailAddress = dictionary["emailAddress"] as? String,
        let profilePic = dictionary["profilePic"] as? UIImage,
        let eventJoined = dictionary["eventJoined"] as? String,
        let eventCreated = dictionary["eventCreated"] as? String,
        let connections = dictionary["connections"] as? String,
        let eventInvites = dictionary["eventInvited"] as? String,
        let connectionRequests = dictionary["connectionRequests"] as? String,
        let groups = dictionary["groups"] as? [Groups],
        let blockedUsers = dictionary["blockedUsers"] as? [AppUser] else {return nil}
        
       self.init(uuid: uuid, name: name, username: username, emailAddress: emailAddress)
    }
}

extension AppUser {
    var dictionary: [String : Any] {
        return [
            "uuid": uuid,
            "name": name,
            "username": username,
            "emailAddress": emailAddress,
            "profilePic": profilePic,
            "eventJoined": eventJoined,
            "eventCreated": eventCreated,
            "connections" : connections,
            "eventInvites" : eventInvites,
            "connectionRequests" : connectionRequests,
            "groups" : groups,
            "blockedUsers" : blockedUsers]
    }

    
}
