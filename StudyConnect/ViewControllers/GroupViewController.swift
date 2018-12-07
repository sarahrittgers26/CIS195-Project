//
//  GroupViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/14/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit
import MessageUI

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    var group: Group?
    var events: [Events] = []
    
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var newEvent: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var join: UIButton!
    @IBOutlet weak var leave: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GroupViewController.reloadEvents),
                                               name: NSNotification.Name(rawValue: "addEventDismissed"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GroupViewController.reloadEvents),
                                               name: NSNotification.Name(rawValue: "eventDeleted"),
                                               object: nil)
        reloadEvents()
        renderMembers()
        if let group = group {
            self.title = "\(group.subject) \(group.courseNum)" }
    }
    
    func setupView() {
        join.layer.cornerRadius = 10
        leave.layer.cornerRadius = 10
        delete.layer.cornerRadius = 10
    }
    
    func reloadGroup() {
        guard let group = group else { return }
        FirebaseGroups.getGroup(groupID: group.id, callback: { (group) in
            self.group = group
            self.renderMembers()
        })
    
    }
    
    // add members
    @objc func renderMembers() {
        // remove existing labels
        for view in self.labelStackView.subviews {
            view.removeFromSuperview()
        }

        guard let group = group else { return }
        FirebaseUsers.getSpecifiedUsers(toGet: group.users, callback: { (users) in
            for user in users {
                let label = UILabel()
                label.text = "\(user.firstName) \(user.lastName)"
                label.font = UIFont(name: "Arial", size: 18)
                label.textColor = UIColor(red: 69/255, green: 134/255, blue: 211/255, alpha: 1)
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
        guard let group = group, let user = FirebaseUsers.getCurrentUser() else { return }
        FirebaseGroups.addMember(groupID: group.id, userID: user.uid, callback: { (bool) in
            if bool {
                self.reloadGroup()
            } else {
                // already a member
                let alert = Helpers.showErrorAlert(message: "You are already a member")
                self.present(alert, animated: true)
            }
        })
    }
    
    @IBAction func leaveGroup(_ sender: Any) {
        guard let group = group, let user = FirebaseUsers.getCurrentUser() else { return }
        FirebaseGroups.removeMember(groupID: group.id, userID: user.uid, callback: { (bool) in
            if bool {
                self.reloadGroup()
            } else {
                // you aren't a member
                let alert = Helpers.showErrorAlert(message: "You are not a member of this group")
                self.present(alert, animated: true)
            }
        })
    }
    
    @IBAction func sendMail(_ sender: Any) {
        if (MFMailComposeViewController.canSendMail()) {
            if let group = group {
                // get users
                FirebaseUsers.getSpecifiedUserEmails(toGet: group.users, callback: { (emails) in
                    
                    let composeVC = MFMailComposeViewController()
                    composeVC.mailComposeDelegate = self
                    composeVC.setToRecipients(emails)
                    let subject = group.subject
                    let num = group.courseNum
                    composeVC.setSubject("\(subject) \(num)")
                    self.present(composeVC, animated: true, completion: nil)
                    
                })
                
            }
        } else {
            let alert = Helpers.showErrorAlert(message: "Mail services are not available")
            self.present(alert, animated: true)
        }
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
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
            let start = Helpers.formatDateAsString(date: event.start)
            let end = Helpers.formatDateAsString(date: event.end)
            eventCell.date.text = "\(start) - \(end)"
            eventCell.location.text = event.address
            return eventCell
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"groupDeleted"), object: nil)
        } else {
            self.dismiss(animated: true, completion: {NotificationCenter.default.post(name: NSNotification.Name(rawValue:"groupDeleted"), object: nil)})
        }
    }

    /*
    // MARK: - Navigation
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddEventViewController {
            let vc = segue.destination as? AddEventViewController
            vc?.group = group
        } else if segue.destination is ShowEventViewController {
            let vc = segue.destination as? ShowEventViewController
            vc?.group = group
            let index = tableView.indexPathForSelectedRow?.row
            let event = self.events[index!]
            vc?.event = event
        }
    }

}
