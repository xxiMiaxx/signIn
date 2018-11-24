//
//  Comment.swift
//  signIn
//
//  Created by Arwa Hamed on 15/03/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import Foundation
class Comment {
    var id:String
    var author:UserProfile
    var text:String
    var timestamp:String
    init(id:String, author:UserProfile,text:String , timestamp:String) {
        self.id = id
        self.author = author
        self.text = text
        self.timestamp = timestamp
    }
}
