//
//  PostTableViewCell.swift
//  signIn
//
//  Created by Arwa Hamed on 22/01/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    //Fav
    
    var link: SubTableViewController?
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
        // Initialization code
        
       // profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
       // profileImageView.clipsToBounds = true
        
    }
    
   
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
     // btnHeart.tintColor = .red
        favBtn.tintColor = .red
     favBtn.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
       //btnHeart = UIBarButtonItem(image: UIImage(named:"add"), style: .plain, target: self, action: #selector(handleMarkAsFavorite))
       
        
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
           // return nil
        }
        //let data = try Data(contentsOf: post.photoURL)
       // profileImageView.image = UIImage(data: data)
       //profileImageView.image =
        
    
    
        
    }
    
   func viewDidLoad() {
    
       // fav.clipsToBounds = true
    //btnHeart.tintColor = .red
    }
    
   
    
    

    
    
    
    
    @objc private func handleMarkAsFavorite() {
//print("Marking as favorite")
         buttonPressed()
         link?.someMethodIWantToCall(cell: self)
        
    }
    
    func buttonPressed() {
        activateButton(bool: !isFavorite)
    }
    
    func activateButton(bool: Bool) {
        
        isFavorite = bool
        
        
        let btnImage = UIButton()
        if(isFavorite ){
          //  btnImage.setImage(UIImage(named: "heart-selected"), for: .normal)
           // favBtn.customView = btnImage
            favBtn.setImage(UIImage(named: "heart-selected"), for: .normal)
        }
        else{
           // btnImage.setImage(UIImage(named: "heart-unselected"), for: .normal)
           // favBtn.customView = btnImage
            favBtn.setImage(UIImage(named: "heart-unselected"), for: .normal)
        }
        
        
    }
    
}
