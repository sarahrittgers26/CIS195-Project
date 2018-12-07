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
    
    static func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    // given an array of user ids, get the emails
    static func getSpecifiedUserEmails(toGet: [String], callback: @escaping([String]) ->Void) {
        let userSet: Set<String> = Set(toGet)
        usersRef.observeSingleEvent(of: .value, with: {(snapshot) in
            var toReturn: [String] = []
            for case let userSnapshot as DataSnapshot in snapshot.children {
                let id = userSnapshot.key
                let values = userSnapshot.value as! [String: Any]
                //                let firstName = values["firstName"] as! String
                //                let lastName = values["lastName"] as! String
                let email = values["email"] as! String
                
                if (userSet.contains(id)) {
                    //                    let user = Users(id: id, firstName: firstName, lastName: lastName, email: email)
                    toReturn.append(email)
                }
            }
            callback(toReturn)
        })
    }
    
    // get the name of user with ID
    static func getNameOfUser(userID: String, callback: @escaping(String) -> ()) {
        usersRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as! [String: Any]
            let firstName = values["firstName"] as! String
            let lastName = values["lastName"] as! String
            callback("\(firstName) \(lastName)")
        })
    }
    
    // return true if the user already exists, otherwise false
    static func checkUserExists(userID: String, callback: @escaping(Bool) -> ()) {
        usersRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                callback(true)
            } else {
                callback(false)
            }
        })
    }
    
    // save an image URL for the user
    static func saveImage(url: String, user_id: String) {
        print("saving picture")
        usersRef.child(user_id).child("profilePicture").setValue(url)
    }
    
    // get the image of the user with ID
    static func getImage(user_id: String, callback: @escaping(String) -> ()) {
        usersRef.child(user_id).observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as! [String: Any]

            if (values["profilePicture"] != nil) {
                let url = values["profilePicture"] as! String
                print(url)
                callback(url)
            } else {
                callback("")
            }
        })
    }
    
}
