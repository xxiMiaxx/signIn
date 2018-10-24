//
//  RestaurantListViewController.swift
//  CollectionRestaurant
//

import UIKit
import FirebaseDatabase
import FirebaseStorage


class RestaurantListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let RestaurantRef = Database.database().reference().child("Restaurants")
    var restaurantList: [RestaurantListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Restaurants"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.white
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        
        
      
       
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRestaurant(_:)))
    }

    override func viewWillAppear(_ animated: Bool) {
         self.fetchAllRestaurant()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @objc func addNewRestaurant(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddRestaurantViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

    func fetchAllRestaurant() {
        
        RestaurantRef.observe(DataEventType.value) { (snapShot) in
            self.restaurantList.removeAll()
            
            if let value = snapShot.value as? [String: AnyObject] {
                for key in value.keys {
    
                    let model = RestaurantListModel(id: key, value: value[key]!)
                    self.restaurantList.append(model)
                }
            }
            
            self.tableView.reloadData()
        }
    }

}

extension RestaurantListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantListTableViewCell") as! RestaurantListTableViewCell
        cell.setUpData(model: restaurantList[indexPath.row])
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        cell.selectionStyle = .none
        return cell
    }
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddRestaurantViewController") as! AddRestaurantViewController
        vc.mode = .edit(restaurantList[indexPath.row].Id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
