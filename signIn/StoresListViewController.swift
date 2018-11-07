

import UIKit
import FirebaseDatabase
import FirebaseStorage


class StoresListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let StoresRef = Database.database().reference()
    var StoresList: [StoresListModel] = []
    
    @IBOutlet weak var btnStore: DropDownMenu!
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Stores"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.white
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewStores(_:)))
        
        btnStore.setTitle(StoreTabes.AccessoriesJewelry.rawValue, for: .normal)
        btnStore.superSuperView = self.view
        btnStore.items = StoreTabes.all.map { $0.rawValue }
        btnStore.didSelectedItemIndex = { index in
            self.selectedIndex = index
            self.btnStore.setTitle(StoreTabes.all[index].rawValue, for: .normal)
            self.fetchAllStores(storeName: StoreTabes.all[index].rawValue)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
         self.fetchAllStores(storeName: StoreTabes.all[selectedIndex].rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addNewStores(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddStoresViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func fetchAllStores(storeName: String) {
        StoresRef.child(storeName).observeSingleEvent(of: .value, with: { (snapShot) in
            self.StoresList.removeAll()
            debugPrint("Called \(snapShot.value)")
            if let value = snapShot.value as? [String: AnyObject] {
                for key in value.keys {
    
                    let model = StoresListModel(id: key, value: value[key]!)
                    self.StoresList.append(model)
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

extension StoresListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StoresList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoresListTableViewCell") as! StoresListTableViewCell
        cell.setUpData(model: StoresList[indexPath.row])
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !btnStore.text.isEmpty {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddStoresViewController") as! AddStoresViewController
            vc.mode = .edit(StoresList[indexPath.row].Id, btnStore.text)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            self.alert(title: "Select Store", messagee: nil, okTitle: "ok")
        }
    }
}

