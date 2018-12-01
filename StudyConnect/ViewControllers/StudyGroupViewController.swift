//
//  StudyGroupViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/14/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit

class StudyGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
  
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // detect when sign up modal closed
        self.tableView.delegate = self
        self.tableView.dataSource = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(StudyGroupViewController.reloadGroups),
                                               name: NSNotification.Name(rawValue: "addGroupDismissed"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(StudyGroupViewController.reloadGroups),
                                               name: NSNotification.Name(rawValue: "groupDeleted"),
                                               object: nil)
        reloadGroups()
    }
    
    @IBAction func search(_ sender: Any) {
        FirebaseGroups.search(term: searchBar.text ?? "") {
            self.tableView.reloadData()
        }
    }
    
    // reload the data into the table when finished querying from firebase
    @objc func reloadGroups() {
        FirebaseGroups.getGroups(callback: {self.tableView.reloadData()})
    }
    
    // actions
    
    @IBAction func searchGroups(_ sender: Any) {
    }
    
    @IBAction func filterGroups(_ sender: Any) {
    }
    
    // Table View Data Source and Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseGroups.allGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studyGroupCell")
        if let groupCell = cell as? StudyGroupTableViewCell {
            let group: Group = FirebaseGroups.getGroup(index: indexPath.row)
            groupCell.classTitle.text = group.subject + " " + group.courseNum
            groupCell.professor.text = "Professor: \(group.professor)"
            groupCell.section.text = "Sections: \(group.sections)"
            // TODO: change
            groupCell.members.text = "Members: \(group.users.count)"
            return groupCell
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
        if segue.destination is GroupViewController {
            let vc = segue.destination as? GroupViewController
            let index = tableView.indexPathForSelectedRow?.row
            let group = FirebaseGroups.getGroup(index: index!)
            vc?.group = group
        }
    }

}
