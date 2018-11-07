

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class EventListTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(model: EventListModel) {
         lblName.text = model.Name
        self.eventImageView.image = #imageLiteral(resourceName: "default_rest_img")
        guard model.EventURL.count != 0 else {
            return
        }
        
        if let url = URL(string: model.EventURL){
            SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions.refreshCached, progress: nil, completed: { (image, _, error, _, _, _) in
                if let pic = image {
                    self.eventImageView.image = pic
                }
            })
        }
    }
}
