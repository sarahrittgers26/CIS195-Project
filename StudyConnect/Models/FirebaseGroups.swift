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
        allGroups.removeAll()
        groupsRef.observeSingleEvent(of: .value, with: {(snapshot) in
//            var allGroups: [Group] = []
            for case let groupSnapshot as DataSnapshot in snapshot.children {
                let id = groupSnapshot.key
                let values = groupSnapshot.value as! NSDictionary
                let subject = values["subject"] as! String
                let number = values["number"] as! String
                let professor = values["professor"] as! String
                let sections = values["sections"] as! String
                
                // get all members of the group
                var allUsers: [String] = []
                if let dict = values.value(forKey: "users") as! NSDictionary? {
                    for (id, _) in dict {
                        if let id = id as? String {
                            allUsers.append(id)
                        }
                    }
                }
                
                // TODO: get all events

                let group = Group(id: id, subject: subject, courseNum: number, professor: professor, sections: sections, users: allUsers, events: [])
                allGroups.append(group)
            }
            FirebaseGroups.allGroups = allGroups
            callback()
        })
    }
    
    static func getSpecificGroups(toGet: [String], callback: @escaping() -> ()) {
        let groupSet: Set<String> = Set(toGet)
        groupsRef.observeSingleEvent(of: .value, with: {(snapshot) in
            //            var allGroups: [Group] = []
            for case let groupSnapshot as DataSnapshot in snapshot.children {
                let id = groupSnapshot.key
                let values = groupSnapshot.value as! NSDictionary
                let subject = values["subject"] as! String
                let number = values["number"] as! String
                let professor = values["professor"] as! String
                let sections = values["sections"] as! String
                
                if (groupSet.contains(id)) {
                
                    // get all members of the group
                    var allUsers: [String] = []
                    if let dict = values.value(forKey: "users") as! NSDictionary? {
                        for (id, _) in dict {
                            if let id = id as? String {
                                allUsers.append(id)
                            }
                        }
                    }
                    
                    // TODO: get all events
                    
                    let group = Group(id: id, subject: subject, courseNum: number, professor: professor, sections: sections, users: allUsers, events: [])
                    allGroups.append(group)
                }
            }
            FirebaseGroups.allGroups = allGroups
            callback()
        })
    }
    
    // get a group with specific id
    static func getGroup(groupID: String, callback: @escaping(Group) -> ()) {
        groupsRef.child(groupID).observeSingleEvent(of: .value, with: {(snapshot) in
            let values = snapshot.value as! NSDictionary
            let subject = values["subject"] as! String
            let number = values["number"] as! String
            let professor = values["professor"] as! String
            let sections = values["sections"] as! String
            
            // get all members of the group
            var allUsers: [String] = []
            if let dict = values.value(forKey: "users") as! NSDictionary? {
                for (id, _) in dict {
                    if let id = id as? String {
                        allUsers.append(id)
                    }
                }
            }
        
        
            // TODO: get all events
        
            let group = Group(id: groupID, subject: subject, courseNum: number, professor: professor, sections: sections, users: allUsers, events: [])
       
            callback(group)
        })

    }
    
    // add a calendar event to the group with id groupId
    static func addEvent(groupId: String, title: String, date: String, time: String, address: String) {
        groupsRef.child(groupId).child("events").childByAutoId().setValue(["title": title, "date": date, "time": time, "address": address])
    }
    
    // get calendar events associated with the group
    static func getEvents(groupId: String, callback: @escaping([Events]) -> ()) {
        groupsRef.child(groupId).child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            var allEvents: [Events] = []
            for case let groupSnapshot as DataSnapshot in snapshot.children {
                let id = groupSnapshot.key
                let values = groupSnapshot.value as! NSDictionary
                let title = values["title"] as! String
                let date = values["date"] as! String
                let time = values["time"] as! String
                let address = values["address"] as! String
                
                // get all confirmed users
                var allUsers: [String] = []
                if let dict = values.value(forKey: "confirmedUsers") as! NSDictionary? {
                    for (id, _) in dict {
                        if let id = id as? String {
                            allUsers.append(id)
                        }
                    }
                }
                
                let event = Events(id: id, title: title, date: date, time: time, address: address, confirmedUsers: allUsers)

                allEvents.append(event)
            }
            callback(allEvents)
        })
    }
    
    static func deleteGroup(groupID: String, callback: @escaping() -> ()) {
        groupsRef.child(groupID).removeValue()
        callback()
    }
    
    // add a user to the group
    static func addMember(groupID: String, userID: String, callback: @escaping(Bool) -> ()) {
        groupsRef.child(groupID).child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                callback(false)
            } else {
                groupsRef.child("\(groupID)/users/\(userID)").setValue("")
                callback(true)
            }
        })
    }
    
    // remove user from group
    static func removeMember(groupID: String, userID: String, callback: @escaping(Bool) -> ()) {
        groupsRef.child(groupID).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChild(userID) {
                // they aren't a member
                callback(false)
            } else {
                groupsRef.child(groupID).child("users").child(userID).removeValue()
                callback(true)
            }
        })
    }
    
    static func confirmUserForEvent(groupID: String, eventID: String, userID: String, callback: @escaping(Bool) -> ()) {
        groupsRef.child(groupID).child("events").child(eventID).child("confirmed").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                callback(false)
            } else {
                groupsRef.child(groupID).child("events").child(eventID).child("confirmed").child(userID).setValue("")
                callback(true)
            }
        })
    }
    
    // delete an event
    static func deleteEvent(groupID: String, eventID: String, callback: @escaping() -> ()) {
        groupsRef.child(groupID).child("events").child(eventID).removeValue()
        callback()
    }
    
    // get a specific event from a group
    static func getEvent(groupID: String, eventID: String, callback: @escaping(Events) -> ()) {
        groupsRef.child(groupID).child("events").child(eventID).observeSingleEvent(of: .value, with: {(snapshot) in
            let values = snapshot.value as! NSDictionary
            let address = values["address"] as! String
            let date = values["date"] as! String
            let time = values["time"] as! String
            let title = values["title"] as! String
            
            // get all confirmed users of the event
            var confirmedUsers: [String] = []
            if let dict = values.value(forKey: "confirmed") as! NSDictionary? {
                for (id, _) in dict {
                    if let id = id as? String {
                        confirmedUsers.append(id)
                    }
                }
            }
            
            let event = Events(id: eventID, title: title, date: date, time: time, address: address, confirmedUsers: confirmedUsers)
            callback(event)
        })
    }
    
}
