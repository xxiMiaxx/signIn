

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class RestaurantListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var resImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
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
        lblName.text = model.Name
        guard model.RestaurantURL.count != 0 else {
            return
        }
        
        if let url = URL(string: model.RestaurantURL){
            SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions.refreshCached, progress: nil, completed: { (image, _, error, _, _, _) in
                if let pic = image {
                    self.resImageView.image = pic
                }
            })
        }
    }
}
