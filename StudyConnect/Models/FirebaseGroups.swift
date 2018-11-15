//
//  FirebaseGroups.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/14/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct FirebaseGroups {
    private static let groupsRef = Database.database().reference(withPath: "groups")
    static var allGroups: [Group] = []
    
    static func count() -> Int {
        return allGroups.count
    }
    
    static func getGroup(index: Int) -> Group {
        return allGroups[index]
    }
    
    // insert group
    static func addGroup(subject: String, courseNumber: String, professor: String, sections: String) {
        let uid = Auth.auth().currentUser?.uid
        groupsRef.childByAutoId().setValue(["subject": subject, "number": courseNumber,
                                            "professor": professor, "sections": sections, "users": [uid: ""]])
        
        
    }
    
    static func getGroups(callback: @escaping() -> ()) {
        groupsRef.observeSingleEvent(of: .value, with: {(snapshot) in
//            var allGroups: [Group] = []
            for case let groupSnapshot as DataSnapshot in snapshot.children {
                let id = groupSnapshot.key
                let values = groupSnapshot.value as! [String: Any]
                let subject = values["subject"] as! String
                let number = values["number"] as! String
                let professor = values["professor"] as! String
                let sections = values["sections"] as! String
                
                let allUsers = values["users"]
                print(id)
                // TODO: get users and events
//                let users = values["users"] as!
                let group = Group(id: id, subject: subject, courseNum: number, professor: professor, sections: sections, users: [], events: [])
                allGroups.append(group)
            }
            // return all groups
//            callback(allGroups)
            FirebaseGroups.allGroups = allGroups
            callback()
        })
    }
}
