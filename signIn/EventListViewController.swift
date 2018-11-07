
import UIKit
import FirebaseDatabase
import FirebaseStorage


class EventListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let EventRef = Database.database().reference().child("Events")
    var EventList: [EventListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Events"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.white
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewEvent(_:)))
    }

    override func viewWillAppear(_ animated: Bool) {
         self.fetchAllEvent()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addNewEvent(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEventViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func fetchAllEvent() {
        
        EventRef.observe(DataEventType.value) { (snapShot) in
            self.EventList.removeAll()
            
            if let value = snapShot.value as? [String: AnyObject] {
                for key in value.keys {
    
                    let model = EventListModel(id: key, value: value[key]!)
                    self.EventList.append(model)
                }
            }
            
            self.tableView.reloadData()
        }
    }
}

extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListTableViewCell") as! EventListTableViewCell
        cell.setUpData(model: EventList[indexPath.row])
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
        vc.mode = .edit(EventList[indexPath.row].Id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
