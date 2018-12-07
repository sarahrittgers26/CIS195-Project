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
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var googleLogin: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // detect when sign up modal closed
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.handleModalDismissed),
                                               name: NSNotification.Name(rawValue: "modalIsDimissed"),
                                               object: nil)
        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
        
        setupView()
    }
    
    func setupView() {
        email.layer.cornerRadius = 15
        email.layer.masksToBounds = true
        password.layer.cornerRadius = 15
        password.layer.masksToBounds = true
        signup.layer.cornerRadius = 10
        login.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // check if user is already logged in
        if (Auth.auth().currentUser != nil) {
            self.performSegue(withIdentifier: "loginToStudy", sender: self)
        }
    }
    
    // fire when sign up model closes and account successfully created
    @objc func handleModalDismissed() {
        // segue to study
        self.performSegue(withIdentifier: "loginToStudy", sender: self)
    }
    
 
    // validate login
    @IBAction func checkLogin(_ sender: Any) {
        if let emailStr = email.text, let passwordStr = password.text {
            Auth.auth().signIn(withEmail: emailStr, password: passwordStr) { (user, error) in
                if let user = user, error == nil {
                    self.email.text = ""
                    self.password.text = ""
                    self.performSegue(withIdentifier: "loginToStudy", sender: self)
                } else {
                    let alert = Helpers.showErrorAlert(message: "Invalid email/password")
                    self.present(alert, animated: true)
                }
            }
        }
    }

    
}

