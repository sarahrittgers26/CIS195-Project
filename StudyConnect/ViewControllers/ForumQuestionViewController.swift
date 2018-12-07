//
//  ForumQuestionViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/27/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit

class ForumQuestionViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var questionLabel: UITextView!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var responsesView: UIStackView!
    @IBOutlet weak var newMessage: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageView: UIStackView!
    
    var question: Question?
    var responses: [Response] = []
    
    var frameView: UIView!
    var messageViewY: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.view.bringSubviewToFront(messageView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        questionLabel.isEditable = false

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
            text.backgroundColor = UIColor(red: 69/255, green: 134/255, blue: 211/255, alpha: 1)
            text.text = "\(response.text)\n- \(response.poster)"
            text.layer.cornerRadius = 15
            text.layer.masksToBounds = true
            text.font = UIFont(name: "Arial", size: 20)
        
            text.textColor = UIColor(red: 208/255, green: 213/255, blue: 217/255, alpha: 1)
            
            self.responsesView.addArrangedSubview(text)
        }
//        scrollToEnd()
    }
    
//    func scrollToEnd() {
//        let contentViewHeight = scrollView.contentSize.height + responsesView.spacing
//        let offsetY = contentViewHeight - scrollView.bounds.height
//        print(Float(contentViewHeight))
//        print(Float(scrollView.bounds.height))
//        print(Float(offsetY))
//        if (offsetY > 0) {
//        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: offsetY), animated: true)
//        }
//    }
    
    @IBAction func post(_ sender: Any) {
        if (newMessage.text == "") {
            let alert = Helpers.showErrorAlert(message: "Message cannot be empty")
            self.present(alert, animated: true)
            return
        }
        
        if let question = question, let response = newMessage.text {
            let id = FirebaseUsers.getCurrentUser()?.uid
            FirebaseUsers.getNameOfUser(userID: id!) { (name) in
                FirebaseForum.addResponse(questionId: question.id, text: response, date: Date().timeIntervalSince1970, poster: name, callback: {
                    self.newMessage.text = ""
                    self.reloadResponses()
                })
            }
        }
    }
    
    // Adjust keyboard height ////////////////////////////////
    
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.messageViewY = self.messageView.frame.origin.y
            self.messageView.frame.origin.y -= (keyboardSize.height - 30)
            
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            self.messageView.frame.origin.y += (keyboardSize.height - 30)
            self.messageView.frame.origin.y = self.messageViewY!
        }
    }

}
