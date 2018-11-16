

import UIKit

class FaciliteListModel: NSObject {
    var Id: String = ""
    var GateNumber: String = ""
    var Location: String = ""
    var Name: String = ""
    
    init(id: String, value: AnyObject) {
        super.init()
        
        self.Id = id
        if let dict = value as? [String: String] {
            GateNumber = dict["Gate"] ?? ""
            Location = dict["loc"] ?? ""
            Name = dict["name"] ?? ""
        }
    }
}
