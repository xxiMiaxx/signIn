//
//  OffersTableViewCell.swift
//  signIn
//
//  Created by Shahad Z on 14/02/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import UIKit

class OffersTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    @IBOutlet weak var Offerimage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(offer:offer) {
     
        
        
        do {
            let data = try Data(contentsOf: offer.photoURL)
           Offerimage.image = UIImage(data: data)
        } catch {
            print("Cannot load image from url:")
            // return nil
        }
    
}
}
