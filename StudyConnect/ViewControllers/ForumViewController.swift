//
//  ForumTableViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/14/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit

class ForumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ForumViewController.reloadQuestions),
                                               name: NSNotification.Name(rawValue: "addQuestionDismissed"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ForumViewController.reloadTable),
                                               name: NSNotification.Name(rawValue: "filterDismissed"),
                                               object: nil)
        reloadQuestions()
    }
    
    @objc func reloadTable() {
        self.tableView.reloadData()
    }
    
    @objc func reloadQuestions() {
        FirebaseForum.getQuestions(callback: {self.tableView.reloadData()})
    }
    
    // Table View Data Source and Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseForum.allQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forumCell")
        if let forumCell = cell as? ForumTableViewCell {
            let question: Question = FirebaseForum.getQuestion(index: indexPath.row)
            forumCell.question.text = question.question
            return forumCell
        }
        return cell!
    }
    
    /*
    // MARK: - Navigation
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ForumQuestionViewController {
            let vc = segue.destination as? ForumQuestionViewController
            let index = tableView.indexPathForSelectedRow?.row
            let question = FirebaseForum.getQuestion(index: index!)
            vc?.question = question
        }
    }

}
