//
//  AddGroupViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/14/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit

class AddGroupViewController: UIViewController {

    @IBOutlet weak var subjectCode: UITextField!
    @IBOutlet weak var courseNumber: UITextField!
    @IBOutlet weak var professor: UITextField!
    @IBOutlet weak var sections: UITextField!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var cancel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        professor.layer.cornerRadius = 15
        professor.layer.masksToBounds = true
        sections.layer.cornerRadius = 15
        sections.layer.masksToBounds = true
        subjectCode.layer.cornerRadius = 15
        subjectCode.layer.masksToBounds = true
        courseNumber.layer.cornerRadius = 15
        courseNumber.layer.masksToBounds = true
        cancel.layer.cornerRadius = 10
        add.layer.cornerRadius = 10
        
        professor.layer.borderWidth = 1
        professor.layer.borderColor = UIColor.lightGray.cgColor
        sections.layer.borderWidth = 1
        sections.layer.borderColor = UIColor.lightGray.cgColor
        subjectCode.layer.borderWidth = 1
        subjectCode.layer.borderColor = UIColor.lightGray.cgColor
        courseNumber.layer.borderWidth = 1
        courseNumber.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func addClass(_ sender: Any) {
        // check that fields are non-empty
        if (subjectCode.text == "" || courseNumber.text == "" || professor.text == "" || sections.text == "") {
            let alert = Helpers.showErrorAlert(message: "Fields cannot be empty")
            self.present(alert, animated: true)
            return
        }
        
        if let subject = subjectCode.text, let number = courseNumber.text, let prof = professor.text, let section = sections.text {
            FirebaseGroups.addGroup(subject: subject, courseNumber: number, professor: prof, sections: section)
            // notify that group was added and modal closed
            self.dismiss(animated: true, completion: {NotificationCenter.default.post(name: NSNotification.Name(rawValue:"addGroupDismissed"), object: nil)})
        }
    }
    
    // close the view
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
