//
//  ProfileViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/14/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        user = Auth.auth().currentUser
        FirebaseUsers.getSpecifiedUsers(toGet: [(user?.uid)!], callback: { (users) in
            self.setupPage(user: users[0])
        })
    }
    
    func setupPage(user: Users) {
        name.text = "\(user.firstName) \(user.lastName)"
        email.text = user.email
    }
    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            
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
