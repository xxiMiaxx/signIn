//
//  UserService.swift
//  signIn
//
//  Created by Arwa Hamed on 16/03/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static var currentUserProfile:UserProfile?
    
    static func observeUserProfile(_ uid:String, completion: @escaping ((_ userProfile:UserProfile?)->())) {
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile:UserProfile?
            
            if let dict = snapshot.value as? [String:Any],
                let userName = dict["userName"] as? String,
                let password = dict["password"] as? String,
                let email = dict["email"] {
                
                userProfile = UserProfile(uid: snapshot.key, userName: userName, email:email as! String, password: password)
            }
            
            completion(userProfile)
        })
    }
}
