//
//  FirebaseStorage.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/30/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

struct FBStorage {
    
    static let ref = Storage.storage().reference().child("profilePictures")
    
    static func savePicture(picture: UIImage, user_id: String) {
        var data = NSData()
        data = picture.jpegData(compressionQuality: 0.0)! as NSData
        let filepath = ref.child("\(user_id)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let uploadTask = filepath.putData(data as Data, metadata: nil) {(metadata, error) in
            guard let metadata = metadata else { return }
            filepath.downloadURL{(url, error) in
                guard let downloadURL = url else { return }
                FirebaseUsers.saveImage(url: downloadURL.absoluteString, user_id: user_id)
            }
        }

    }
    
    static func getPicture(user_id: String, callback: @escaping(UIImage) -> ()) {
        FirebaseUsers.getImage(user_id: user_id) { (url) in
            if (url != "") {
                let storageRef = Storage.storage().reference(forURL: url)
                storageRef.getData(maxSize: 1 * 1200 * 1200) { (data, error) -> Void in

                    if let data = data {
                        // Create a UIImage, add it to the array
                        let pic = UIImage(data: data)
                        callback(pic ?? UIImage(named: "profile-default")!)
                    }
                }
            }
        }
    }

}
