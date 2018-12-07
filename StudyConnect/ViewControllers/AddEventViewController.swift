//
//  AddEventViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/14/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {

    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var create: UIButton!
    
    var start =  0
    var end = 0
    
    var group: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(AddEventViewController.changeAddress),
                                           name: NSNotification.Name(rawValue: "addressSelected"),
                                           object: nil)
    }
    
    func setupView() {
        eventTitle.layer.cornerRadius = 15
        eventTitle.layer.masksToBounds = true
        address.layer.cornerRadius = 15
        address.layer.masksToBounds = true
        cancel.layer.cornerRadius = 10
        create.layer.cornerRadius = 10
        
        eventTitle.layer.borderWidth = 1
        eventTitle.layer.borderColor = UIColor.lightGray.cgColor
        address.layer.borderWidth = 1
        address.layer.borderColor = UIColor.lightGray.cgColor
        
        startDate.minuteInterval = 15
        endDate.minuteInterval = 15
        
        start = Int(startDate.date.timeIntervalSince1970)
        end = Int(endDate.date.timeIntervalSince1970)
    }
    
    // change the address field
    @objc func changeAddress(notification: Notification) {
        let passedData = notification.userInfo as! [String: String]
        address.text = passedData["address"]
    }
    
    @IBAction func startChanged(_ sender: UIDatePicker) {
        start = Int(sender.date.timeIntervalSince1970)
    }
    
    
    @IBAction func endChanged(_ sender: UIDatePicker) {
        end = Int(sender.date.timeIntervalSince1970)
    }
    
    @IBAction func createEvent(_ sender: Any) {
        if let titleStr = eventTitle.text, let addressStr = address.text, let group = group {
        
            if titleStr == "" || addressStr == "" || start == 0 || end == 0 {
                let alert = Helpers.showErrorAlert(message: "Fields cannot be empty")
                self.present(alert, animated: true)
            } else {
                FirebaseGroups.addEvent(groupId: group.id, title: titleStr, start: start, end: end, address: addressStr)
                self.dismiss(animated: true, completion: {NotificationCenter.default.post(name: NSNotification.Name(rawValue:"addEventDismissed"), object: nil)})
            }
        }
    }
    
    @IBAction func showMapSearch(_ sender: Any) {
        performSegue(withIdentifier: "mapSegue", sender: nil)
    }
    
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

