

import UIKit
import FirebaseDatabase
import FirebaseStorage


class FaciliteListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let FaciliteRef = Database.database().reference()
    var FaciliteList: [FaciliteListModel] = []
    
    @IBOutlet weak var btnFacilite: DropDownMenu!
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Facilite"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.white
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewFacilite(_:)))
        
        btnFacilite.superSuperView = self.view
        btnFacilite.items = FaciliteTabes.all.map { $0.rawValue }
        btnFacilite.didSelectedItemIndex = { index in
            self.selectedIndex = index
            self.btnFacilite.setTitle(FaciliteTabes.all[index].rawValue, for: .normal)
            self.fetchAllFacilite(FaciliteName: FaciliteTabes.all[index].rawValue)
        }
        btnFacilite.selectedIndex = 0
    }
    override func viewWillAppear(_ animated: Bool) {
         self.fetchAllFacilite(FaciliteName: FaciliteTabes.all[selectedIndex].rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addNewFacilite(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddFaciliteViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func fetchAllFacilite(FaciliteName: String) {
        FaciliteRef.child(FaciliteName).observeSingleEvent(of: .value, with: { (snapShot) in
            self.FaciliteList.removeAll()
            if let value = snapShot.value as? [String: AnyObject] {
                for key in value.keys {
    
                    let model = FaciliteListModel(id: key, value: value[key]!)
                    self.FaciliteList.append(model)
                }
            }
            self.tableView.reloadData()
        })
    }

    func alert(title: String?, messagee: String?, okTitle: String) {
        let alert = UIAlertController(title: title, message: messagee, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension FaciliteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FaciliteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaciliteListTableViewCell") as! FaciliteListTableViewCell
        cell.setUpData(model: FaciliteList[indexPath.row])
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !btnFacilite.text.isEmpty {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddFaciliteViewController") as! AddFaciliteViewController
            vc.mode = .edit(FaciliteList[indexPath.row].Id, btnFacilite.text)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            self.alert(title: "Select Facilite", messagee: nil, okTitle: "ok")
        }
    }
}

