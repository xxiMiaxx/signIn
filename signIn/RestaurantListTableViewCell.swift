//
//  RestaurantListTableViewCell.swift
//  CollectionRestaurant
//


import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class RestaurantListTableViewCell: UITableViewCell {

    @IBOutlet weak var resImageView: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblGateNumber: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(model: RestaurantListModel) {
        self.resImageView.image = #imageLiteral(resourceName: "default_rest_img")
        
        guard model.RestaurantURL.count != 0 else {
            return
        }
        
        let storageRef = Storage.storage().reference().child("\(model.RestaurantURL)")
        storageRef.downloadURL { (url, error) in
            
            SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions.refreshCached, progress: nil, completed: { (image, _, error, _, _, _) in
                
                if let pic = image {
                    self.resImageView.image = pic
                }
                else{
                    self.resImageView.image = #imageLiteral(resourceName: "default_rest_img")
                    debugPrint(error ?? "Error On Downloading image")
                }
            })
        }
        
        lblGateNumber.text = model.Name
//        lblPhoneNumber.text = model.Name
//        lblGateNumber.text = "Gate Number: \(model.GateNumber)"
//        lblDescription.text = "Description: \(model.Description)"
//        lblLocation.text = "Location: \(model.Location)"
    }

}
