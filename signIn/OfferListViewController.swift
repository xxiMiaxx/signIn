
import UIKit
import FirebaseDatabase
import FirebaseStorage


class OfferListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let OfferRef = Database.database().reference().child("Offers")
    var offerList: [OfferListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Offers"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.white
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        
        
       
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewOffer(_:)))
    }

    override func viewWillAppear(_ animated: Bool) {
         self.fetchAllOffer()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addNewOffer(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddOfferViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func fetchAllOffer() {
        
        OfferRef.observe(DataEventType.value) { (snapShot) in
            self.offerList.removeAll()
            debugPrint(snapShot)
            if let value = snapShot.value as? [String: AnyObject] {
                for key in value.keys {
                    
                    let model = OfferListModel(id: key, value: value[key]!)
                    self.offerList.append(model)
                }
            }
            
            self.tableView.reloadData()
        }
    }

}

extension OfferListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferListTableViewCell") as! OfferListTableViewCell
        cell.setUpData(model: offerList[indexPath.row])
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddOfferViewController") as! AddOfferViewController
        vc.mode = .edit(offerList[indexPath.row].Id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
