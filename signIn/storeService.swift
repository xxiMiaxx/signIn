//
//  storeService.swift
//  signIn
//
//  Created by Arwa Hamed on 23/01/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import Foundation
import FirebaseDatabase

class storeService {
    
    static var currentStoreProfile:storeProfile?
    
    static func observeStoreProfile (_ uid:String , complition: @escaping ((_ storeProfile:storeProfile?) -> ())) {
        
        let storeRef = Database.database().reference().child("rest")
        
        storeRef.observe(.value, with: {snapshot in
            
            var StoreProfile: storeProfile?
            
            if let dict = snapshot.value as? [String:Any],
               let name = dict["name"] as? String ,
               let photoURL = dict["photoURL"] as? String,
               let url = URL(string:photoURL) {
                
                StoreProfile = storeProfile( photoURL:url , name: name )
                
                
                
            }
            
            
             complition(StoreProfile)
            
            
        })
        
    }
        
        
    
    
    
    
    
}
