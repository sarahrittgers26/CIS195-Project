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
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var address: UITextField!
    
    
    var group: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AddEventViewController.changeAddress),
                                               name: NSNotification.Name(rawValue: "addressSelected"),
                                               object: nil)
    }
    
    // change the address field
    @objc func changeAddress(notification: Notification) {
        let passedData = notification.userInfo as! [String: String]
        address.text = passedData["address"]
    }
    
    @IBAction func createEvent(_ sender: Any) {
        if let titleStr = eventTitle.text, let dateStr = date.text, let timeStr = time.text, let addressStr = address.text, let group = group {
        
            if titleStr == "" || dateStr == "" || timeStr == "" || addressStr == "" {
                let alert = Helpers.showErrorAlert(message: "Fields cannot be empty")
                self.present(alert, animated: true)
            } else {
                FirebaseGroups.addEvent(groupId: group.id, title: titleStr, date: dateStr, time: timeStr, address: addressStr)
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

