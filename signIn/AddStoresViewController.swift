

import UIKit
import Photos
import PhotosUI
import FirebaseDatabase
import FirebaseStorage
import MobileCoreServices
import SDWebImage
import NVActivityIndicatorView

enum StoreMethodMode {
    case add
    case edit(String, String)
}

enum StoreTabes: String {
    case AccessoriesJewelry = "Accessories & Jewelry"
    case BagsShoes = "Bags & Shoes"
    case ChildrenShops = "Children Shops"
    case Clothes = "Clothes"
    case CoffeShopsBakeries = "Coffee Shops & Bakeries"
    case Home
    case PerfumesAndBeauty = "Perfumes and Beauty"
    case PharmacyOptics = "Pharmacy & Optics"
    case Sport
    
    static var all: [StoreTabes] = [
        StoreTabes.AccessoriesJewelry,
        .BagsShoes,
        .ChildrenShops,
        .Clothes,
        .CoffeShopsBakeries,
        .Home,
        .PerfumesAndBeauty,
        .PharmacyOptics,
        .Sport
    ]
}

class AddStoresViewController: UIViewController, NVActivityIndicatorViewable {
    
    private var pickerController = UIImagePickerController()
    
    @IBOutlet weak var resImageView: UIImageView!
    @IBOutlet weak var btnStore: DropDownMenu!
    @IBOutlet weak var btnGateNumber: DropDownMenu!
    @IBOutlet weak var btnLocation: DropDownMenu!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var btnAddOrEdit: UIButton!
    
    var imageSelected: UIImage? = nil
    
    var StoresRef = Database.database().reference()
    
    var mode: StoreMethodMode = StoreMethodMode.add

    var locationPickerData = [String]()
    var gatePickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Stores"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapHandler(_:)))
        
        resImageView.addGestureRecognizer(tapGesture)
        
        locationPickerData = ["Ground floor", "First floor"]
        gatePickerData = ["Gate 1", "Gate 2", "Gate 3", "Gate 4"]
        
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
        
        btnStore.setTitle("Select Store", for: .normal)
        btnStore.superSuperView = self.view
        btnStore.items = StoreTabes.all.map { $0.rawValue }
        btnStore.didSelectedItemIndex = { index in
            self.btnStore.setTitle(StoreTabes.all[index].rawValue, for: .normal)
        }
        
        isEditAction()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        btnStore.reloadInputViews()
    }
    
    @objc func imageTapHandler(_ sender: UITapGestureRecognizer) {
        self.openImagePicker()
    }
    
    @objc func deleteStores() {
        
        switch mode {
            case .add: break
            case .edit(let id, let store):
                StoresRef.child(store).child(id).removeValue { (error, refrece) in
                    self.navigationController?.popViewController(animated: true)
                }
            break
        }
    }
    
    func isEditAction() {
        switch mode {
        case .add:
            btnStore.isEnabled = true
            break
            
        case .edit(let id, let store):
            self.title = "Edit Stores"
            btnAddOrEdit.setTitle("Edit", for: .normal)
            btnStore.isEnabled = false
            btnStore.text = store
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteStores))
            let StoresRef = Database.database().reference().child(store)
            StoresRef.child(id).observeSingleEvent(of: .value) { (snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    if let Gate = value["Gate"] as? String {
                        self.btnGateNumber.text = Gate
                        self.btnGateNumber.selectedIndex = 0
                    }
                    if let loc = value["loc"] as? String {
                        self.btnLocation.text = loc
                        self.btnLocation.selectedIndex = 0
                    }
                    self.btnStore.selectedIndex = 0
                    self.btnStore.text = store
                    self.title = value["name"] as? String
                    self.txtName.text = value["name"] as? String
                    self.txtPhoneNumber.text = value["phone"] as? String
                    let StoresURL: String = value["photoURL"] as? String ?? ""
                    self.title = value["name"] as? String
                    guard StoresURL.count != 0 else {
                        return
                    }
                    
                    if let url = URL(string: StoresURL){
                        SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions.refreshCached, progress: nil, completed: { (image, _, error, _, _, _) in
                            
                            if let pic = image {
                                self.imageSelected = pic
                                self.resImageView.image = pic
                            }
                            else{
                                self.resImageView.image = #imageLiteral(resourceName: "default_rest_img")
                                debugPrint(error ?? "Error On Downloading image")
                            }
                        })
                    }
                    else{
                        self.resImageView.image = #imageLiteral(resourceName: "default_rest_img")
                        debugPrint("Error On Downloading image")
                    }
                    
                }
            }
        }
    }
    
    func openImagePicker() {
        let mediaType = AVMediaType.video
        let authStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        
        switch (PHPhotoLibrary.authorizationStatus(), authStatus) {
        case (.authorized, AVAuthorizationStatus.authorized):
            setupAlertController()
            break
            
        case (.notDetermined, AVAuthorizationStatus.notDetermined):
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized{
                    AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { (granted) in
                        if granted {
                            self.setupAlertController()
                        }
                    })
                }
            })
            break
        default:
            let alert = UIAlertController(title: "App Permission Denied", message: "To re-enable, please go to Settings and turn on Photo Library Service for this app.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Setting", style: .default, handler: { _ in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
                } else {
                    UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
                }
            })
            alert.addAction(action)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            
            break
        }
    }
    
    
    private func presentPicker(with sourceType: UIImagePickerControllerSourceType){
        
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            return
        }
        
        pickerController.delegate = self
        pickerController.mediaTypes = [kUTTypeImage as String]
        pickerController.allowsEditing = false
        pickerController.modalPresentationStyle = .overFullScreen
        pickerController.sourceType = sourceType
        
        DispatchQueue.main.async {
            self.present(self.pickerController, animated: true, completion: nil)
        }
    }
    
    
    private func setupAlertController() {
        
        let alert = UIAlertController(title: "Choose Option", message: "Select an option to pick an image", preferredStyle: .actionSheet)
        
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            let action = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                self.presentPicker(with: .camera)
            })
            alert.addAction(action)
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.presentPicker(with: .photoLibrary)
        })
        alert.addAction(photoLibrary)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.presentPicker(with: .photoLibrary)
        })
        alert.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func addStores(_ sendre: UIButton) {
        
        if checkTextField() == false{ return}
        
        startAnimating(CGSize(width:50, height:50), type: NVActivityIndicatorType(rawValue: 32), color: UIColor(red: 0x4D/255, green: 0x11/255, blue: 0x11/255, alpha: 1.0))
        if let image = imageSelected {
            
            
            let storageRef = Storage.storage().reference().child("\(timestamp).jpg")
            
            if let uploadData = UIImageJPEGRepresentation(image, 0.5) {
                
                storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                    if let data = metaData {
                        if let _ = data.name{
                            storageRef.downloadURL { (url, error) in
                               self.uploadDataOnFirebase(with: url?.description ?? "")
                            }
                        }
                        else{
                            self.uploadDataOnFirebase(with: "")
                        }
                    }
                    else{
                        debugPrint(error ?? "Error On Upload")
                        self.uploadDataOnFirebase(with: "")
                    }
                }
            }
            else{
                self.uploadDataOnFirebase(with: "")
            }
        }
        else{
            uploadDataOnFirebase(with: "")
        }
    }
    
    var timestamp: String = {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }()
    
    func checkTextField()->Bool{
        if imageSelected == nil{
            self.alert(title: "Please select an image", messagee: nil, okTitle: "Ok")
            
        }else if(btnStore.selectedIndex == -1){
            self.alert(title: "Select Store Name", messagee: nil, okTitle: "Ok")
            
        }else if(txtName.text == ""){
            self.alert(title: txtName.placeholder, messagee: nil, okTitle: "Ok")
            
        }else if(txtPhoneNumber.text == ""){
            self.alert(title: txtPhoneNumber.placeholder, messagee: nil, okTitle: "Ok")
            
        }else if(btnLocation.selectedIndex == -1){
            self.alert(title: "Select Location", messagee: nil, okTitle: "Ok")
            
        }else if(btnGateNumber.selectedIndex == -1){
            self.alert(title: "Select Gate Number", messagee: nil, okTitle: "Ok")
        }
        else{
            return true
        }
        return false
    }
    
    func uploadDataOnFirebase(with url: String) {
        let parameters: [AnyHashable : Any] = [
            "Gate": btnGateNumber.text,
            "loc": btnLocation.text,
            "name": txtName.text ?? "",
            "phone": txtPhoneNumber.text ?? "",
            "photoURL": url
        ]
        debugPrint(parameters)
        
        switch mode {
        case .add:
            
            StoresRef.child(btnStore.text).queryOrdered(byChild: "name").queryEqual(toValue : txtName.text!).observeSingleEvent(of: .value) { (snapshot) in
                
                for child in (snapshot.children.allObjects as? [DataSnapshot]) ?? [] {
                    
                    print(child.key)
                    self.stopAnimating()
                    self.alert(title: "Stores already exists.", messagee: nil, okTitle: "Ok")
                    return
                }
                
                self.StoresRef.child(self.btnStore.text).childByAutoId().setValue(parameters, withCompletionBlock:  { (error, dataRef) in
                    if error == nil {
                        debugPrint(dataRef.key as Any)
                        self.clearValue()
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
            
        case .edit(let id, let store):
            StoresRef.child(store).child(id).updateChildValues(parameters) { (error, dataRef) in
                if error == nil {
                    debugPrint(dataRef.key as Any)
                    self.clearValue()
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
        self.txtPhoneNumber.text = ""
        self.txtName.text = ""
        self.resImageView.image = #imageLiteral(resourceName: "default_rest_img")
        self.imageSelected = nil
    }
}

extension AddStoresViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true) {
            var newImage: UIImage? = nil
            if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                newImage = possibleImage
            } else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                newImage = possibleImage
            }
            self.imageSelected = newImage
            self.resImageView.image = newImage
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { }
    }
}

