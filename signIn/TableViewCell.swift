//
//  TableViewCell.swift
//  signIn
//
//  Created by Shahad Z on 10/02/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var Eimage: UIImageView!
    
   
    
    @IBOutlet weak var desc: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func set(event:event) {
        desc.text = event.desc
      
        
        do {
            let data = try Data(contentsOf: event.photoURL)
           Eimage.image = UIImage(data: data)
        } catch {
            print("Cannot load image from url:")
            // return nil
        }
        //let data = try Data(contentsOf: post.photoURL)
        // profileImageView.image = UIImage(data: data)
        //profileImageView.image =
        
        
        
        
    }
    
    
    
}
