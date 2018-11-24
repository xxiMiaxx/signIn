//
//  NewPostViewController.swift
//  signIn
//
//  Created by Arwa Hamed on 15/03/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewPostViewController: UIViewController , UITextViewDelegate {

    @IBOutlet weak var commentLable: UITextField!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    var userName:String!
    var storeName: String? = nil
    var storeName2:String!
   // static var storeName:String?
    @IBAction func handlePostBtn(_ sender: Any) {
        
        guard let userProfile = UserService.currentUserProfile else { return }
        
        //get username START
        let currentUserID = Auth.auth().currentUser?.uid
        let usersRef = Database.database().reference().child("users/profile")
        usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                if  let childSnapshot = child as? DataSnapshot ,
                    let dict = childSnapshot.value as? [String:Any] ,
                    let userName = dict["userName"] as? String,
                    let userID = childSnapshot.key as? String,
                    let photoURL = dict["photoURL"] as? String ,
                    let url = URL(string:photoURL) {
                    if userID.uppercased() == currentUserID?.uppercased()  {
                      self.userName = userName
                        print("userName")
                        print(userName)
                    }
                }
            }
        })
        //get username END
        
        //get store name START
        
        
        //get store name END
        
        // Save the comment in Firebase START
        // current date
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let stringDate = dateFormatter.string(from: date as Date)
        print(stringDate)
        print("stringDate")
        
        let reviewRef = Database.database().reference().child("reviews").childByAutoId()
        print(self.userName)
        print("self.userName")
        let reviewObject = [
            "author":[
                "uid": userProfile.uid,
                "username": userProfile.userName
            ],
            "text": commentLable.text ?? "nil",
            "timestamp": stringDate,
            "storeName": self.storeName
            ] as [String:Any]
        
        reviewRef.setValue(reviewObject, withCompletionBlock: { error, ref in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Handle the error
            }
        })
        
       
        // Save the comment in Firebase END
        
    }
    
    
    
    @IBAction func handleCancelBtn(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    

    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        //textView.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            super.dismiss(animated: flag, completion: completion)
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  cancelBtn.tintColor = .black
      //  doneBtn.tintColor = .black
        //textView.delegate = self
       
        self.storeName = GlobalVariables.sharedManager.myName
        print(self.storeName)
        print("AAARRRWWWAAA")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //textView.becomeFirstResponder()
        // Remove the nav shadow underline
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func textViewDidChange(_ textView: UITextView) {
       // placeHolderLabel.isHidden = !textView.text.isEmpty
    }
}
