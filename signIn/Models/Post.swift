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
   // var location:String
    var loc: String
    var photoURL: URL
    var phone:String
   
    
    init (name:String , photoURL: URL , phone:String , loc: String) {
        self.name = name
        
        self.phone = phone
        self.photoURL = photoURL 
        self.loc = loc
    }
    
    
}
