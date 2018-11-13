//
//  ViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/12/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
 

    @IBAction func checkLogin(_ sender: Any) {
        if let emailStr = email.text, let passwordStr = password.text {
            Auth.auth().signIn(withEmail: emailStr, password: passwordStr) { (user, error) in
                if let user = user, error == nil {
                    self.performSegue(withIdentifier: "loginToStudy", sender: self)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Invalid email/password", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    
                    self.present(alert, animated: true)
                }
            }
        }
    }

    
}

