//
//  PostTableViewCell.swift
//  signIn
//
//  Created by Arwa Hamed on 22/01/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class PostTableViewCell: UITableViewCell {
    
    //Fav
    
    var link: SubTableViewController?
    var Link: Favorites?
    var isFavorite = false
    
    //Fav
    
    @IBOutlet weak var fav: UIToolbar!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var favBtn: UIButton!
   // @IBOutlet weak var btnHeart: UIButton!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var postTextLable: UILabel!
    @IBOutlet weak var subtitleLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
   
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        favBtn.tintColor = .red
        favBtn.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
     
       
        
    }
    
 
    
    
    
    func set(post:Post) {
        
       userNameLable.text = post.name
       subtitleLable.text = post.phone
       postTextLable.text = post.loc
     //  Location.text = post.location
        
        do {
            let data = try Data(contentsOf: post.photoURL)
            profileImageView.image = UIImage(data: data)
        } catch {
            print("Cannot load image from url:") 
        }
        //
        
        viewDidLoad()
        
        //
        
        
        
    }
    
   
   func viewDidLoad() {
    
    let favRef = Database.database().reference().child("users/favList")
    favRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
        
        let currentUserID = Auth.auth().currentUser?.uid
        
        for child in snapshot.children {
            if  let childSnapshot = child as? DataSnapshot ,
                let dict = childSnapshot.value as? [String:Any] ,
                let userID = dict["userID"] as? String ,
                let name = dict["name"] as? String ,
                let photoURL = dict["photoURL"] as? String ,
                let loc = dict["loc"] as? String ,
                let phone = dict["phone"] as? String ,
                let url = URL(string:photoURL) {
                if userID == currentUserID && name == self.userNameLable.text{
                    self.favBtn.setImage(UIImage(named: "heart-selected"), for: .normal)
                    
                }
            }
        }
        
        
        
    })
    
    }
    
    @objc private func handleMarkAsFavorite() {
         buttonPressed()
    }
    
    func buttonPressed() {
        activateButton(bool: !isFavorite)
    }
    
    func activateButton(bool: Bool) {
        isFavorite = bool
        
        if(isFavorite ){
            link?.someMethodIWantToCall(cell: self)
            favBtn.setImage(UIImage(named: "heart-selected"), for: .normal)
        }
        else{
            link?.someMethodIWantToCallDelete(cell: self)
            favBtn.setImage(UIImage(named: "heart-unselected"), for: .normal)
        }
    }
    
}
