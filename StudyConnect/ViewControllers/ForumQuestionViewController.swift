//
//  ForumQuestionViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/27/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit

class ForumQuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UITextView!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var responsesView: UIStackView!
    @IBOutlet weak var newMessage: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var question: Question?
    var responses: [Response] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.isEditable = false
        newMessage.becomeFirstResponder()
        // Do any additional setup after loading the view.
        if let question = question {
            questionLabel.text = question.question
            schoolLabel.text = "School: \(question.school)"
            tagLabel.text = "Tag: \(question.tag)"
        }
        reloadResponses()
    }
    
    func reloadResponses() {
        responses.removeAll()
        if let question = question {
            FirebaseForum.getResponses(questionId: question.id, callback: { (responseArray) in
                for response in responseArray {
                    self.responses.append(response)
                }
                
                // sort in descending order
                self.responses.sort(by: {$0.date < $1.date })
                self.renderResponses()
            })
        }
    }
    
    func renderResponses() {
        // remove existing labels
        for view in self.responsesView.subviews {
            view.removeFromSuperview()
        }
        
        for response in responses {
            let text = UITextView()
            text.isScrollEnabled = false
            text.isEditable = false
            text.backgroundColor = UIColor(red: 231/255, green: 236/255, blue: 239/255, alpha: 1)
            text.text = response.text
            text.font = UIFont (name: "Poppins", size: 17)
        
            text.textColor = UIColor(red: 139/255, green: 140/255, blue: 137/255, alpha: 1)
            
//            text.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            
            self.responsesView.addArrangedSubview(text)
        }
    }
    
    @IBAction func post(_ sender: Any) {
        if (newMessage.text == "") {
            let alert = Helpers.showErrorAlert(message: "Message cannot be empty")
            self.present(alert, animated: true)
            return
        }
        
        if let question = question, let response = newMessage.text {
            FirebaseForum.addResponse(questionId: question.id, text: response, date: Date().timeIntervalSince1970, callback: {
                self.newMessage.text = ""
                self.reloadResponses()
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
