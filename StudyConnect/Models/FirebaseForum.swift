//
//  FirebaseForum.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/27/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct FirebaseForum {
    private static let forumRef = Database.database().reference(withPath: "forum")
    static var allQuestions: [Question] = []
    
    // get the question at specified index
    static func getQuestion(index: Int) -> Question {
        return allQuestions[index]
    }
    
    // get all forum questions
    static func getQuestions(callback: @escaping() -> ()) {
        allQuestions.removeAll()
        forumRef.observeSingleEvent(of: .value, with: {(snapshot) in
            //            var allGroups: [Group] = []
            for case let questionSnapshot as DataSnapshot in snapshot.children {
                let id = questionSnapshot.key
                let values = questionSnapshot.value as! NSDictionary
                let q = values["question"] as! String
                let school = values["school"] as! String
                let tag = values["tag"] as! String
                let date = values["date"] as! Double
                
                let question = Question(id: id, question: q, school: school, tag: tag, date: date)
                allQuestions.append(question)
            }
            FirebaseForum.allQuestions = allQuestions
            callback()
        })
    }
    
    static func filterQuestions(schoolFilter: String, tagFilter: String, callback: @escaping() -> ()) {
        print("filtering")
        allQuestions.removeAll()
        forumRef.observeSingleEvent(of: .value, with: {(snapshot) in
            for case let questionSnapshot as DataSnapshot in snapshot.children {
                let id = questionSnapshot.key
                let values = questionSnapshot.value as! NSDictionary
                let q = values["question"] as! String
                let school = values["school"] as! String
                let tag = values["tag"] as! String
                let date = values["date"] as! Double

                if ((schoolFilter == school && tagFilter == tag) ||
                    (schoolFilter == "All" && tagFilter == tag ||
                    (schoolFilter == school && tagFilter == "All"))) {
                    let question = Question(id: id, question: q, school: school, tag: tag, date: date)
                    allQuestions.append(question)
                }
            }
            FirebaseForum.allQuestions = allQuestions
            callback()
        })
    }
    
    // insert question
    static func addQuestion(question: String, school: String, tag: String, date: Double) {
        forumRef.childByAutoId().setValue(["question": question, "school": school, "tag": tag, "date": date])
    }
    
    // add a response
    static func addResponse(questionId: String, text: String, date: Double, callback: @escaping() -> ()) {
        forumRef.child(questionId).child("responses").childByAutoId().setValue(["text": text, "date": date]) { (err, ref) in
            callback()
        }
    }
    
    // get responses associated with a question
    static func getResponses(questionId: String, callback: @escaping([Response]) -> ()) {
        forumRef.child(questionId).child("responses").observeSingleEvent(of: .value, with: {(snapshot) in
            var allResponses: [Response] = []
            for case let questionSnapshot as DataSnapshot in snapshot.children {
                let id = questionSnapshot.key
                
                let values = questionSnapshot.value as! NSDictionary
                let text = values["text"] as! String
                let date = values["date"] as! Double
                
                let response = Response(id: id, text: text, date: date)
                
                allResponses.append(response)
            }
            callback(allResponses)
        })
    }
    
    
}
