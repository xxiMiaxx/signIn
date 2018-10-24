//
//  CategoryViewController.swift
//  CollectionRestaurant


import UIKit
import FirebaseAuth



class CategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var category: [String] = ["Restaurant", "Stores", "Offers", "Events", "Facilites", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Admin"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        cell?.backgroundColor = UIColor(red: 255/255, green: 193/255, blue: 143/255, alpha: 1.0)
        cell?.tintColor = UIColor.white
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.text = category[indexPath.row]
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // logout
        switch category[indexPath.row] {
            
        case "Restaurant":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantListViewController")
            self.navigationController?.pushViewController(vc!, animated: true)
            break
            
        case "Logout":
          
            do {
               try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
                AppDelegate.shared.window?.rootViewController = vc
                AppDelegate.shared.window?.makeKeyAndVisible()
            }
            catch {
                Helper.alert(title: "Sign out", messagee: error.localizedDescription, okTitle: "ok", okHandler: nil)
            }
            
            break
        default:
            break
        }
    }
}


class Helper: NSObject {
    
    static func alert(title: String?, messagee: String?, okTitle: String, okHandler: (() -> ())?) {
        let alert = UIAlertController(title: title, message: messagee, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: { (action) in
            okHandler?()
        })
        alert.addAction(okAction)
        
        AppDelegate.topViewController()?.present(alert, animated: true, completion: nil)
    }
}

extension AppDelegate {
    
    public class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
