//
//  ForumFilterViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/30/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit

class ForumFilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var schoolPicker: UIPickerView!
    @IBOutlet weak var tagPicker: UIPickerView!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var filter: UIButton!
    
    var schoolData: [String] = []
    var tagData: [String] = []
    var schoolPickerValue = "All"
    var tagPickerValue = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        schoolData = ["All", "College", "Engineering", "Nursing", "Wharton"]
        tagData = ["All", "Requirements", "Registration", "Class Recommendations", "Internships", "Jobs", "Other"]
        
        schoolPicker.dataSource = self
        schoolPicker.delegate = self
        tagPicker.dataSource = self
        tagPicker.delegate = self
        
        setupView()
    }
    
    func setupView() {
        cancel.layer.cornerRadius = 10
        filter.layer.cornerRadius = 10
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func filter(_ sender: Any) {
        FirebaseForum.filterQuestions(schoolFilter: schoolPickerValue, tagFilter: tagPickerValue, callback: {
            self.dismiss(animated: true, completion: {NotificationCenter.default.post(name: NSNotification.Name(rawValue:"filterDismissed"), object: nil)})
        })
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
