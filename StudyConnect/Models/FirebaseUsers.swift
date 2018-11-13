//
//  FirebaseUsers.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/13/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct FirebaseUsers {
    private static let usersRef = Database.database().reference(withPath: "users")
    
    static func addUser(userID: String, firstName: String, lastName: String) {
        
        usersRef.child(userID).setValue([firstName: firstName, lastName: lastName])
        
    }
    
}
