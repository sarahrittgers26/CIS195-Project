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

            let group = Group(id: groupID, subject: subject, courseNum: number, professor: professor, sections: sections, users: allUsers, events: [])
       
            callback(group)
        })

    }
    
    // search for groups with course numbers/subjects matching a term
    static func search(term: String, callback: @escaping() -> ()) {
        if (term.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            return FirebaseGroups.getGroups(callback: callback)
        }
        let searchterm = term.lowercased()
        
        allGroups.removeAll()
        groupsRef.observeSingleEvent(of: .value, with: {(snapshot) in
            for case let groupSnapshot as DataSnapshot in snapshot.children {
                let id = groupSnapshot.key
                let values = groupSnapshot.value as! NSDictionary
                let subject = values["subject"] as! String
                let number = values["number"] as! String
                let professor = values["professor"] as! String
                let sections = values["sections"] as! String
                
                if (subject.lowercased().contains(searchterm)) {
                
                    // get all members of the group
                    var allUsers: [String] = []
                    if let dict = values.value(forKey: "users") as! NSDictionary? {
                        for (id, _) in dict {
                            if let id = id as? String {
                                allUsers.append(id)
                            }
                        }
                    }
                    
                    let group = Group(id: id, subject: subject, courseNum: number, professor: professor, sections: sections, users: allUsers, events: [])
                    allGroups.append(group)
                }
            }
            FirebaseGroups.allGroups = allGroups
            callback()
        })
    }
    
    // add a calendar event to the group with id groupId
    static func addEvent(groupId: String, title: String, start: Int, end: Int, address: String) {
        let eventRef = groupsRef.child(groupId).child("events").childByAutoId()
        eventRef.setValue(["title": title, "start": start, "end": end, "address": address])
    }
    
    // get calendar events associated with the group
    static func getEvents(groupId: String, callback: @escaping([Events]) -> ()) {
        groupsRef.child(groupId).child("events").observeSingleEvent(of: .value, with: {(snapshot) in
            var allEvents: [Events] = []
            for case let groupSnapshot as DataSnapshot in snapshot.children {
                let id = groupSnapshot.key
                let values = groupSnapshot.value as! NSDictionary
                let title = values["title"] as! String
                let start = values["start"] as! Int
                let end = values["end"] as! Int
                let address = values["address"] as! String
                
                // get all confirmed users
                var allUsers: [String] = []
                if let dict = values.value(forKey: "confirmed") as! NSDictionary? {
                    for (id, _) in dict {
                        if let id = id as? String {
                            allUsers.append(id)
                        }
                    }
                }
                
                let event = Events(id: id, title: title, start: Date(timeIntervalSince1970: Double(start)), end: Date(timeIntervalSince1970: Double(end)), address: address, confirmedUsers: allUsers)

                allEvents.append(event)
            }
            callback(allEvents)
        })
    }
    
    // deletes a study group
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
    
    // confirm that the user is going to an event
    static func confirmUserForEvent(groupID: String, eventID: String, userID: String, callback: @escaping(Bool) -> ()) {
        groupsRef.child(groupID).child("events").child(eventID).child("confirmed").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
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
        groupsRef.child(groupID).child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(eventID) {
                groupsRef.child(groupID).child("events").child(eventID).removeValue()
            }
            callback()
        })
        
    }
    
    // get a specific event from a group
    static func getEvent(groupID: String, eventID: String, callback: @escaping(Events) -> ()) {
        groupsRef.child(groupID).child("events").child(eventID).observeSingleEvent(of: .value, with: {(snapshot) in
            let values = snapshot.value as! NSDictionary
            let address = values["address"] as! String
            let start = values["start"] as! Int
            let end = values["end"] as! Int
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
            
            let event = Events(id: eventID, title: title, start: Date(timeIntervalSince1970: Double(start)), end: Date(timeIntervalSince1970: Double(end)), address: address, confirmedUsers: confirmedUsers)
            callback(event)
        })
    }
    
}
