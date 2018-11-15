//
//  GroupViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/14/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var group: Group?
    var events: [Events] = []
    
    // keep track of members and created labels
//    var members: [Users] = []
//    var memberLabels: [UILabel] = []
    
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var newEvent: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GroupViewController.reloadEvents),
                                               name: NSNotification.Name(rawValue: "addEventDismissed"),
                                               object: nil)
        reloadEvents()
        renderMembers()
    }
    
    func reloadGroup() {
        guard let group = group else { return }
        FirebaseGroups.getGroup(groupID: group.id, callback: { (group) in
            self.group = group
            self.renderMembers()
        })
    
    }
    
    // add members
    func renderMembers() {
        // remove existing labels
        for view in self.labelStackView.subviews {
            view.removeFromSuperview()
        }
        
        guard let group = group else { return }
        FirebaseUsers.getSpecifiedUsers(toGet: group.users, callback: { (users) in
            for user in users {
                let label = UILabel()
                label.text = "\(user.firstName) \(user.lastName)"
                label.textColor = UIColor(red: 139/255, green: 140/255, blue: 137/255, alpha: 1)
                self.labelStackView.addArrangedSubview(label)
                
            }
        })
    }
    
    @objc func reloadEvents() {
        events.removeAll()
        if let group = group {
            FirebaseGroups.getEvents(groupId: group.id, callback: { (events) in
                for event in events {
                    self.events.append(event)
                }
                self.tableView.reloadData()
            })
        }
    }
    
    // Actions
    @IBAction func joinGroup(_ sender: Any) {
    }
    
    @IBAction func leaveGroup(_ sender: Any) {
    }
    
    @IBAction func deleteGroup(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "This cannot be undone", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) in
            // do nothing
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction!) in
            if let group = self.group {
                FirebaseGroups.deleteGroup(groupID: group.id, callback: {
                    self.performSegueToReturnBack()
                })
            }
        }))
        self.present(alert, animated: true)
    }
    
    
    // Table View Data Source and Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupEventCell")
        if let eventCell = cell as? EventTableViewCell {
            let event: Events = self.events[indexPath.row]
            eventCell.title.text = event.title
            eventCell.date.text = "\(event.date) \(event.time)"
            eventCell.location.text = event.address
            return eventCell
        }
        return cell!
    }
    
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"groupDeleted"), object: nil)
            print("hi")
        } else {
            self.dismiss(animated: true, completion: {NotificationCenter.default.post(name: NSNotification.Name(rawValue:"groupDeleted"), object: nil)})
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddEventViewController {
            let vc = segue.destination as? AddEventViewController
            vc?.group = group
        }
    }

}
