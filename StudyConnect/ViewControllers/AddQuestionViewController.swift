//
//  AddQuestionViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/27/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit

class AddQuestionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var school: UIPickerView!
    @IBOutlet weak var tag: UIPickerView!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var post: UIButton!
    
    var schoolData: [String] = []
    var tagData: [String] = []
    var schoolPickerValue = ""
    var tagPickerValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        schoolData = ["College", "Engineering", "Nursing", "Wharton"]
        tagData = ["Requirements", "Registration", "Class Recommendations", "Internships", "Jobs", "Other"]
        
        school.dataSource = self
        school.delegate = self
        tag.dataSource = self
        tag.delegate = self
        
        setupView()
    }
    
    func setupView() {
        question.layer.cornerRadius = 15
        question.layer.masksToBounds = true
        cancel.layer.cornerRadius = 10
        post.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        question.becomeFirstResponder()
    }
    

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func post(_ sender: Any) {
        // check that fields are non-empty
        if (question.text == "" || schoolPickerValue == "" || tagPickerValue == "") {
            let alert = Helpers.showErrorAlert(message: "Fields cannot be empty")
            self.present(alert, animated: true)
            return
        }
        
        if let q = question.text {
            FirebaseForum.addQuestion(question: q, school: schoolPickerValue, tag: tagPickerValue, date: Date().timeIntervalSince1970)
            // notify that question was added and modal closed
            self.dismiss(animated: true, completion: {NotificationCenter.default.post(name: NSNotification.Name(rawValue:"addQuestionDismissed"), object: nil)})
        }
    }
    
    // Pickers
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return schoolData.count
        } else {
            return tagData.count
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return schoolData[row]
        } else {
            return tagData[row]
        }
    }
    
    // set the selected value of the picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            schoolPickerValue = schoolData[pickerView.selectedRow(inComponent: 0)]
        } else {
            tagPickerValue = tagData[pickerView.selectedRow(inComponent: 0)]
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
