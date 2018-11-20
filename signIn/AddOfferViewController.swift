
import UIKit
import Photos
import PhotosUI
import FirebaseDatabase
import FirebaseStorage
import MobileCoreServices
import SDWebImage
import NVActivityIndicatorView


class AddOfferViewController: UIViewController, NVActivityIndicatorViewable {
    
    private var pickerController = UIImagePickerController()
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var iss:Bool = true
    var dateformatter = DateFormatter()
    
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var txtSdate: UITextField!
    @IBOutlet weak var txtEdate: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnAddOrEdit: UIButton!
    
    var imageSelected: UIImage? = nil
    
    var OfferRef = Database.database().reference().child("Offers")
    
    var mode:ActionMethodMode = ActionMethodMode.add
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Offer"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapHandler(_:)))
        offerImageView.addGestureRecognizer(tapGesture)
        
        isEditAction()
        
        self.dateView.isHidden = true
        
        dateformatter.dateFormat = "dd/MM/YYYY"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func imageTapHandler(_ sender: UITapGestureRecognizer) {
        self.openImagePicker()
    }
    
    @objc func deleteOffer() {
        
        switch mode {
            case .add: break
            case .edit(let id):
                OfferRef.child(id).removeValue { (error, refrece) in
                    self.navigationController?.popViewController(animated: true)
                }
            break
        }
    }
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        self.dateView.isHidden = true
        if iss{
            txtSdate.text = dateformatter.string(from: datePicker.date)
        }else{
            txtEdate.text = dateformatter.string(from: datePicker.date)
        }
    }
    @IBAction func btnCancelAction(_ sender: UIButton) {

        self.dateView.isHidden = true
    }
    
    @IBAction func btnStartDate(_ sender:UIButton){
        if(txtSdate.text != ""){
            datePicker.date = dateformatter.date(from: txtSdate.text!) ?? Date()
        }
        self.dateView.isHidden = false
        iss = true
    }
    @IBAction func btnEndDate(_ sender:UIButton){
        if(txtEdate.text != ""){
            datePicker.date = dateformatter.date(from: txtEdate.text!) ?? Date()
        }
        self.dateView.isHidden = false
        iss = false
    }
    
    func isEditAction() {
        switch mode {
        case .add: break
            
        case .edit(let id):
            self.title = "Edit Offer"
            btnAddOrEdit.setTitle("Edit", for: .normal)
            
            print("ss"+id)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteOffer))
            let OfferRef = Database.database().reference().child("Offers")
            OfferRef.child(id).observeSingleEvent(of: .value) { (snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    self.title = value["name"] as? String
                    self.txtName.text = value["name"] as? String
                    self.txtSdate.text = value["Sdate"] as? String
                    self.txtEdate.text = value["Edate"] as? String
                    let OfferURL: String = value["photoURL"] as? String ?? ""
                    
                    
                    guard OfferURL.count != 0 else {
                        return
                    }
                    
                    if let url = URL(string: OfferURL){
                        SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions.refreshCached, progress: nil, completed: { (image, _, error, _, _, _) in
                            
                            if let pic = image {
                                self.imageSelected = pic
                                self.offerImageView.image = pic
                            }
                            else{
                                self.offerImageView.image = #imageLiteral(resourceName: "default_rest_img")
                                debugPrint(error ?? "Error On Downloading image")
                            }
                        })
                    }
                    else{
                        self.offerImageView.image = #imageLiteral(resourceName: "default_rest_img")
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
    
    
    @IBAction func addOffer(_ sendre: UIButton) {
        
        if checkTextField() == false{ return}
        
        startAnimating(CGSize(width:50, height:50), type: NVActivityIndicatorType(rawValue: 32), color: UIColor(red: 0x4D/255, green: 0x11/255, blue: 0x11/255, alpha: 1.0))
        if let image = imageSelected {
            
            
            let storageRef = Storage.storage().reference().child("\(timestamp).jpg")
            
            if let uploadData = UIImageJPEGRepresentation(image, 0.5) {
                
                storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                    if let data = metaData {
                        if let _ = data.name{
                            storageRef.downloadURL { (url, error) in
                                print("ss")
                                debugPrint(url)
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
            
        }else if(txtName.text == ""){
            self.alert(title: txtName.placeholder, messagee: nil, okTitle: "Ok")
            
        }else if(txtSdate.text == ""){
            self.alert(title: txtSdate.placeholder, messagee: nil, okTitle: "Ok")
            
        }else if(txtEdate.text == ""){
            self.alert(title: txtEdate.placeholder, messagee: nil, okTitle: "Ok")
        
        }
        else{
            return true
        }
        return false
    }
    
    func uploadDataOnFirebase(with url: String) {
        let parameters: [AnyHashable : Any] = [
            "Sdate": txtSdate.text ?? "",
            "Edate": txtEdate.text ?? "",
            "name": txtName.text ?? "",
            "photoURL": url
        ]
        
        debugPrint(parameters)
        switch mode {
        case .add:
            
            OfferRef.queryOrdered(byChild: "name").queryEqual(toValue : txtName.text!).observeSingleEvent(of: .value) { (snapshot) in
                
                for child in (snapshot.children.allObjects as? [DataSnapshot]) ?? [] {
                    
                    print(child.key)
                    self.stopAnimating()
                    self.alert(title: "Offer already exists.", messagee: nil, okTitle: "Ok")
                    return
                }
                self.OfferRef.childByAutoId().setValue(parameters, withCompletionBlock:  { (error, dataRef) in
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
            
        case .edit(let id):
            OfferRef.child(id).updateChildValues(parameters) { (error, dataRef) in
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
        self.txtSdate.text = ""
        self.txtEdate.text = ""
        self.txtName.text = ""
        self.offerImageView.image = #imageLiteral(resourceName: "default_rest_img")
        self.imageSelected = nil
    }
}


extension AddOfferViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true) {
            var newImage: UIImage? = nil
            if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                newImage = possibleImage
            } else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                newImage = possibleImage
            }
            self.imageSelected = newImage
            self.offerImageView.image = newImage
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { }
    }
}
