//
//  ProfileViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/14/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var logout: UIButton!
    
    
    var user: User?
    
    let libraryPicker = UIImagePickerController()
    let albumPicker = UIImagePickerController()
    let cameraPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        user = Auth.auth().currentUser
        
        FirebaseUsers.getSpecifiedUsers(toGet: [(user?.uid)!], callback: { (users) in
            self.setupPage(user: users[0])
        })
        
        FBStorage.getPicture(user_id: (user?.uid)!) { (image) in
            
            self.profilePicture.contentMode = .scaleAspectFill
            self.profilePicture.image = image
            
            self.profilePicture.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
            self.profilePicture.contentMode = .scaleAspectFill
            self.profilePicture.autoresizesSubviews = false
            self.profilePicture.layer.cornerRadius = 0.5 * 150
        }
        
        libraryPicker.delegate = self
        albumPicker.delegate = self
        cameraPicker.delegate = self
        
    }
    
    func setupView() {
        logout.layer.cornerRadius = 10
    }
    
    @IBAction func changeProfilePicture(_ sender: Any) {
        let alert = UIAlertController(title: "Media Types", message: "Select the media source for your profile picture", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {_ in self.photoLibrary()}))
        alert.addAction(UIAlertAction(title: "Saved Photos Album", style: .default, handler: {_ in self.album()}))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {_ in self.camera()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: false)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePicture.contentMode = .scaleAspectFill
            profilePicture.image = image
            profilePicture.autoresizesSubviews = false
            profilePicture.layer.cornerRadius = 0.5 * 150
            FBStorage.savePicture(picture: image, user_id: (user?.uid)!)
            picker.dismiss(animated: false, completion: nil)
        }
    }
    
    func photoLibrary() {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            libraryPicker.allowsEditing = false
            libraryPicker.sourceType = .photoLibrary
            libraryPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(libraryPicker, animated: false)
        }
    }
    
    func album() {
        if (UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)) {
            albumPicker.allowsEditing = false
            albumPicker.sourceType = .savedPhotosAlbum
            albumPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
            self.present(albumPicker, animated: false)
        }
    }
    
    func camera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            cameraPicker.allowsEditing = false
            cameraPicker.sourceType = .camera
            cameraPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            self.present(cameraPicker, animated: false)
        }
    }
    
    func setupPage(user: Users) {
        name.text = "\(user.firstName) \(user.lastName)"
        email.text = user.email
    }
    
    
    
    @IBAction func logout(_ sender: Any) {
        do {
            GIDSignIn.sharedInstance()?.signOut()
            try Auth.auth().signOut()
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        } catch {
            
        }
    }

}
