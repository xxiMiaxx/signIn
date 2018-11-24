//
//  UserProfile.swift
//  signIn
//
//  Created by Arwa Hamed on 16/03/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import Foundation
class UserProfile {
    var uid:String
    var email:String
    var password:String
    var userName:String
    
    init(uid:String, userName:String , email:String,password:String) {
        self.uid = uid
        self.userName = userName
        self.email = email
        self.password = password
   }
    
    
}
