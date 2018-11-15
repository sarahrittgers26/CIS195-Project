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
    
    // insert user 
    static func addUser(userID: String, firstName: String, lastName: String, email: String) {
        
        usersRef.child(userID).setValue(["firstName": firstName, "lastName": lastName, "email": email])
        
    }
    
    static func getAllUsers(callback: @escaping([Users]) -> ()) {
        usersRef.observeSingleEvent(of: .value, with: {(snapshot) in
            var allUsers: [Users] = []
            for case let userSnapshot as DataSnapshot in snapshot.children {
                let id = userSnapshot.key
                let values = userSnapshot.value as! [String: Any]
                let firstName = values["firstName"] as! String
                let lastName = values["lastName"] as! String
                let email = values["email"] as! String
                
                let user = Users(id: id, firstName: firstName, lastName: lastName, email: email)
                allUsers.append(user)
            }
            callback(allUsers)
        })
    }
    
    // given an array of user ids
    static func getSpecifiedUsers(toGet: [String], callback: @escaping([Users]) ->Void) {
//        let userSet: Set<String> = Set(toGet.map{ $0.email })
        let userSet: Set<String> = Set(toGet)
        usersRef.observeSingleEvent(of: .value, with: {(snapshot) in
            var allUsers: [Users] = []
            for case let userSnapshot as DataSnapshot in snapshot.children {
                let id = userSnapshot.key
                let values = userSnapshot.value as! [String: Any]
                let firstName = values["firstName"] as! String
                let lastName = values["lastName"] as! String
                let email = values["email"] as! String
                
                if (userSet.contains(id)) {
                    let user = Users(id: id, firstName: firstName, lastName: lastName, email: email)
                    allUsers.append(user)
                }
            }
            callback(allUsers)
        })
    }
    
    
    
}
