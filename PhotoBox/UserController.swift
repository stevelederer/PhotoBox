//
//  UserController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/18/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation


class UserController {
    
    static let shared = UserController()
    private init (){}
    
    var currentUser: AppUser? {
        didSet {
            print("Current User is: \(String(describing: currentUser?.username))")
        }
    }
    
    func signUpUser() {
        
    }
    
    
    func createUser() {
        <#code#>
    }
    
    func updateUser() {
        <#code#>
    }
    
    func deleteUser() {
        <#code#>
    }
    
    
    
}
