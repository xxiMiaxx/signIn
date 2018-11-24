//
//  GlobalVariables.swift
//  signIn
//
//  Created by Arwa Hamed on 16/03/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import Foundation

class GlobalVariables {
    
    // These are the properties you can store in your singleton
    var myName: String = "nil"
    
    
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}
