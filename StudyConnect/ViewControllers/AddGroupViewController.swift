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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
