//
//  PostTableViewCell.swift
//  signIn
//
//  Created by Arwa Hamed on 22/01/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
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
    
}
