
import UIKit

class OfferListModel: NSObject {
    var Id: String = ""
    var Name: String = ""
    var OfferURL: String = ""
    var Sdate: String = ""
    var Edate: String = ""
    
    init(id: String, value: AnyObject) {
        super.init()
        
        self.Id = id
        if let dict = value as? [String: String] {
            Name = dict["name"] ?? ""
            OfferURL = dict["photoURL"] ?? ""
            Sdate = dict["Sdate"] ?? ""
            Edate = dict["Edate"] ?? ""
        }
    }
}
