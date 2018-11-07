

import UIKit

class EventListModel: NSObject {
    var Id: String = ""
    var Location: String = ""
    var Desc: String = ""
    var Name: String = ""
    var Sdate: String = ""
    var Edate: String = ""
    var EventURL: String = ""
    
    init(id: String, value: AnyObject) {
        super.init()
        
        self.Id = id
        if let dict = value as? [String: String] {
            Location = dict["loc"] ?? ""
            Desc = dict["desc"] ?? ""
            Name = dict["name"] ?? ""
            EventURL = dict["photoURL"] ?? ""
            Sdate = dict["Sdate"] ?? ""
            Edate = dict["Edate"] ?? ""
        }
    }
}
