

import UIKit
import Photos
import PhotosUI
import FirebaseDatabase
import FirebaseStorage
import MobileCoreServices
import SDWebImage
import NVActivityIndicatorView

enum FaciliteMethodMode {
    case add
    case edit(String, String)
}

enum FaciliteTabes: String {

    case WomanToilets = "Woman Toilets"
    case MenToilets = "Men Toilets"
    case Mosque
    case ATM
    case ParkingLots = "Parking lots"
    case LostandFounds = "Lost and Founds"
    case WomanPrayerRoom = "Woman prayer room"
    case ChangingRooms = "Changing rooms"
    
    static var all: [FaciliteTabes] = [
        .WomanToilets,
        .MenToilets,
        .Mosque,
        .ATM,
        .ParkingLots,
        .LostandFounds,
        .WomanPrayerRoom,
        .ChangingRooms
    ]
}

class AddFaciliteViewController: UIViewController, NVActivityIndicatorViewable {
    
    private var pickerController = UIImagePickerController()
    
    @IBOutlet weak var btnFacilite: DropDownMenu!
    @IBOutlet weak var btnGateNumber: DropDownMenu!
    @IBOutlet weak var btnLocation: DropDownMenu!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var btnAddOrEdit: UIButton!

    var FacilitesRef = Database.database().reference()
    
    var mode: FaciliteMethodMode = FaciliteMethodMode.add

    var locationPickerData = [String]()
    var gatePickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Facilite"

        locationPickerData = ["First floor", "Second floor"]
        gatePickerData = ["Gate 1", "Gate 2", "Gate 3", "Gate 4", "Gate 5"]
        
        btnGateNumber.setTitle("Select Gate Number", for: .normal)
        btnGateNumber.superSuperView = self.view
        btnGateNumber.items = gatePickerData
        btnGateNumber.direction = .top
        btnGateNumber.didSelectedItemIndex = { index in
            self.btnGateNumber.setTitle(self.gatePickerData[index], for: .normal)
        }
        
        btnLocation.setTitle("Select Location", for: .normal)
        btnLocation.superSuperView = self.view
        btnLocation.items = locationPickerData
        btnLocation.didSelectedItemIndex = { index in
            self.btnLocation.setTitle(self.locationPickerData[index], for: .normal)
        }
        
        btnFacilite.setTitle("Select Facilite", for: .normal)
        btnFacilite.superSuperView = self.view
        btnFacilite.items = FaciliteTabes.all.map { $0.rawValue }
        btnFacilite.didSelectedItemIndex = { index in
            self.btnFacilite.setTitle(FaciliteTabes.all[index].rawValue, for: .normal)
        }
        
        isEditAction()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        btnFacilite.reloadInputViews()
    }
    
    @objc func deleteFacilites() {
        
        switch mode {
            case .add: break
            case .edit(let id, let Facilite):
                FacilitesRef.child(Facilite).child(id).removeValue { (error, refrece) in
                    self.navigationController?.popViewController(animated: true)
                }
            break
        }
    }
    
    func isEditAction() {
        switch mode {
        case .add:
            btnFacilite.isEnabled = true
            break
            
        case .edit(let id, let Facilite):
            self.title = "Edit Facilites"
            btnAddOrEdit.setTitle("Edit", for: .normal)
            btnFacilite.isEnabled = false
            btnFacilite.text = Facilite
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteFacilites))
            let FacilitesRef = Database.database().reference().child(Facilite)
            FacilitesRef.child(id).observeSingleEvent(of: .value) { (snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    if let Gate = value["Gate"] as? String {
                         //////////////////////////
                        self.btnGateNumber.text = Gate
                         //////////////////////////
                    }
                    if let loc = value["loc"] as? String {
                         //////////////////////////
                        self.btnLocation.text = loc
                         //////////////////////////
                    }
                    self.btnFacilite.text = Facilite
                    self.title = value["name"] as? String
                    self.txtName.text = value["name"] as? String
                    
                }
            }
        }
    }
    

    @IBAction func addFacilites(_ sendre: UIButton) {
        
        if checkTextField() == false{ return}
        
        startAnimating(CGSize(width:50, height:50), type: NVActivityIndicatorType(rawValue: 32), color: UIColor(red: 0x4D/255, green: 0x11/255, blue: 0x11/255, alpha: 1.0))
         self.uploadDataOnFirebase()
    }
    
    var timestamp: String = {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }()
    
    func checkTextField()->Bool{
        if(btnFacilite.selectedIndex == -1){
            self.alert(title: "Select Facilite Name", messagee: nil, okTitle: "ok")
            
        }else if(txtName.text == ""){
            self.alert(title: txtName.placeholder, messagee: nil, okTitle: "ok")
            
        }else if(btnLocation.selectedIndex == -1){
            self.alert(title: "Select Location", messagee: nil, okTitle: "ok")
            
        }else if(btnGateNumber.selectedIndex == -1){
            self.alert(title: "Select Gate Number", messagee: nil, okTitle: "ok")
        }
        else{
            return true
        }
        return false
    }
    
    func uploadDataOnFirebase() {
        let parameters: [AnyHashable : Any] = [
            "Gate": btnGateNumber.text,
            "loc": btnLocation.text,
            "name": txtName.text ?? ""
        ]
        debugPrint(parameters)
        
        switch mode {
        case .add:
            
            FacilitesRef.child(btnFacilite.text).queryOrdered(byChild: "name").queryEqual(toValue : txtName.text!).observeSingleEvent(of: .value) { (snapshot) in
                
                for child in (snapshot.children.allObjects as? [DataSnapshot]) ?? [] {
                    
                    print(child.key)
                    self.stopAnimating()
                    self.alert(title: "Same name Facilites available. Please try another Name", messagee: nil, okTitle: "ok")
                    return
                }
                self.FacilitesRef.child(self.btnFacilite.text).childByAutoId().setValue(parameters, withCompletionBlock:  { (error, dataRef) in
                    if error == nil {
                        debugPrint(dataRef.key as Any)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        if let e = error {
                            self.alert(title: nil, messagee: e.localizedDescription, okTitle: "Ok")
                        }
                        debugPrint(error as Any)
                    }
                    self.stopAnimating()
                })
            }
            break
            
        case .edit(let id, let Facilite):
            FacilitesRef.child(Facilite).child(id).updateChildValues(parameters) { (error, dataRef) in
                if error == nil {
                    debugPrint(dataRef.key as Any)
                   
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    if let e = error {
                        self.alert(title: nil, messagee: e.localizedDescription, okTitle: "Ok")
                    }
                    debugPrint(error as Any)
                }
                self.stopAnimating()
            }
        }
    }
    
    func alert(title: String?, messagee: String?, okTitle: String) {
        let alert = UIAlertController(title: title, message: messagee, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func clearValue() {
        self.btnGateNumber.text = ""
        self.btnLocation.text = ""
        self.txtName.text = ""
    }
}
