//
//  Groups.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation

class Group {
    
    let members: [AppUser]
   
    init(members: [AppUser]) {
        
        self.members = members
    }
}
