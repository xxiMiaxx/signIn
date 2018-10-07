//
//  Post.swift
//  signIn
//
//  Created by Arwa Hamed on 23/01/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import Foundation

class Post {
    
    var name:String
   
    var type: String
    var photoURL: URL
    var phone:String
   
    
    init (name:String , type: String ,photoURL: URL , phone:String ) {
        self.name = name
        self.type = type
        self.phone = phone
        self.photoURL = photoURL 
      //  self.timestamp = timestamp
    }
    
    
}
