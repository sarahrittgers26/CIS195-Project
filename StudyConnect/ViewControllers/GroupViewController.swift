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
    var members: [Users] = []
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var newEvent: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
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
        guard let group = group else { return }
        FirebaseUsers.getSpecifiedUsers(toGet: group.users, callback: { (users) in
            self.members = users
            
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
