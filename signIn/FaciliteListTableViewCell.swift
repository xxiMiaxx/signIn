

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class FaciliteListTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(model: FaciliteListModel) {
        lblName.text = model.Name
    }
}
