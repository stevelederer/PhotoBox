//
//  User.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class User: FirestoreFetchable {
    
    
    static let CollectionName: String = "users"
    
    let uuid: String
    var name: String
    var username: String
    var emailAddress: String
    var profilePic: UIImage?
    var eventJoined: String //is this a string?
    var eventCreated: String //is this a string?
    var connections: String
    var eventInvites: String //is this a string?
    var connectionRequests: String //is this a string?
    var groups: [Groups]
    var blockedUsers: [User]
    
    init(uuid: String = UUID().uuidString, name: String, username: String, emailAddress: String, profilePic: UIImage, eventJoined: String, eventCreated: String, connections: String, eventInvites: String, connectionRequests: String, groups: [Groups], blockedUsers: [User]) {
        
        self.uuid = uuid
        self.name = name
        self.username = username
        self.emailAddress = emailAddress
        self.profilePic = profilePic
        self.eventJoined = eventJoined
        self.eventCreated = eventCreated
        self.connections = connections
        self.eventInvites = eventInvites
        self.connectionRequests = connectionRequests
        self.groups = groups
        self.blockedUsers = blockedUsers
        
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
        let blockedUsers = dictionary["blockedUsers"] as? [User] else {return nil}
        
        self.init(uuid: id, name: name, username: username, emailAddress: emailAddress, profilePic: profilePic, eventJoined: eventJoined, eventCreated: eventCreated, connections: connections, eventInvites: eventInvites, connectionRequests: connectionRequests, groups: groups, blockedUsers: blockedUsers)
    }
}

extension User {
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
