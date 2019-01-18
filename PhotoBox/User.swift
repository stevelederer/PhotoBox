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
        let profilePicURL = dictionary["profilePicURL"] as? String,
        let memberEventIDs = dictionary["memberEventIDs"] as? String,
        let creatorEventIDs = dictionary["creatorEventIDs"] as? String,
        let inviteEventIDs = dictionary["inviteEventIDs"] as? String,
        let connectionsIDs = dictionary["connectionsIDs"] as? String,
        let connectionInvitesIDs = dictionary["connectionInvitesIDs"] as? String,
        let groups = dictionary["groups"] as? [Groups],
        let blockedUsers = dictionary["blockedUsers"] as? [String] else {return nil}
        
       self.init(uuid: id, name: name, username: username, emailAddress: emailAddress)
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
            "profilePicURL" : profilePicURL,
            "memberEventIDs": memberEventIDs,
            "creatorEventIDs": creatorEventIDs,
            "inviteEventIDs" : inviteEventIDs,
            "connectionsIDs" : connectionIDs,
            "connectionInvitesIDs" : connectionInviteIDs,
            "groups" : groups,
            "blockedUsersIDs" : blockedUserIDs]
    }

    
}
