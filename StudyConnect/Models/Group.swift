//
//  Group.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/14/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import Foundation

struct Group {
 
    let id: String
    let subject: String
    let courseNum: String
    let professor: String
    let sections: String
    let users: [String] // list of user IDs
    let events: [Events]
    
}
