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
    var groupIDs: [String]?
    var connections: [BasicProfile]?
    var groups: [Group]?
    var events: [BasicEvent]?
    var blockedUserIDs: [String]?
    
    
    init(uuid: String = UUID().uuidString, name: String, username: String, emailAddress: String, profilePicURL: String? = nil, memberEventIDs: [String]? = nil, creatorEventIDs: [String]?  = nil, inviteEventIDs: [String]? = nil, connectionIDs: [String]? = nil, connectionInviteIDs: [String]? = nil, groupIDs: [String]? = nil, connections: [BasicProfile]? = nil, groups: [Group]? = nil, events: [BasicEvent]? = nil, blockedUserIDs: [String]? = nil) {
        
        self.uuid = uuid
        self.name = name
        self.username = username
        self.emailAddress = emailAddress
        self.profilePicURL = profilePicURL
        self.memberEventIDs = memberEventIDs
        self.creatorEventIDs = creatorEventIDs
        self.inviteEventIDs = inviteEventIDs
        self.connectionIDs = connectionIDs
        self.connectionInviteIDs = connectionInviteIDs
        self.groupIDs = groupIDs
        self.connections = connections
        self.groups = groups
        self.events = events
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
        if let memberEventIDs = dictionary["memberEventIDs"] as? [String] {
            self.memberEventIDs = memberEventIDs
        }
        if let creatorEventIDs = dictionary["creatorEventIDs"] as? [String]? {
            self.creatorEventIDs = creatorEventIDs
        }
        if let inviteEventIDs = dictionary["inviteEventIDs"] as? [String]? {
            self.inviteEventIDs = inviteEventIDs
        }
        if let connectionIDs = dictionary["connectionIDs"] as? [String]? {
            self.connectionIDs = connectionIDs
        }
        if let connectionInviteIDs = dictionary["connectionInvitesIDs"] as? [String]? {
            self.connectionInviteIDs = connectionInviteIDs
        }
        if let groupIDs = dictionary["groupIDs"] as? [String]? {
            self.groupIDs = groupIDs
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
            "memberEventIDs": memberEventIDs,
            "creatorEventIDs": creatorEventIDs,
            "inviteEventIDs" : inviteEventIDs,
            "connectionsIDs" : connectionIDs,
            "connectionInviteIDs" : connectionInviteIDs,
            "groups" : groups,
            "blockedUsersIDs" : blockedUserIDs
        ]
    }
}
