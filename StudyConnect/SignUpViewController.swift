//
//  SignUpViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/12/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // sign up button clicked
    @IBAction func signUp(_ sender: Any) {
        // check that fields are non-empty
        if (firstName.text == "" || lastName.text == "" || email.text == "" || password.text == "") {
            let alert = Helpers.showErrorAlert(message: "Fields cannot be empty")
            self.present(alert, animated: true)
            return
        }
        
        // must sign in with upenn email
        if (!email.text!.contains("upenn.edu")) {
            let alert = Helpers.showErrorAlert(message: "Must use UPenn email")
            self.present(alert, animated: true)
            return
        }
        
        if let email = email.text, let password = password.text, let firstName = firstName.text, let lastName = lastName.text {
            // create new auth user
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let user = authResult?.user {
                    // add user data to firebase
                    FirebaseUsers.addUser(userID: user.uid, firstName: firstName, lastName: lastName)
                    // dismiss modal and let parent vc know that sign up was successful
                    self.dismiss(animated: true, completion: {NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil)})
                } else {
                    let alert = UIAlertController(title: "Error", message: "Problem creating user", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    // cancel button clicked
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
