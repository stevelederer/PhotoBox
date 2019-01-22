//
//  Groups.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation

class Group {
    
    var groupName: String
    var coverPhotoURL: String?
    let members: [String]
    
    init(groupName: String, coverPhotoURL: String, members: [String]) {
        self.groupName = groupName
        self.coverPhotoURL = coverPhotoURL
        self.members = members
    }
}
