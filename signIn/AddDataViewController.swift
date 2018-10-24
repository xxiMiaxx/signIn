//
//  AddDataViewController.swift
//  CollectionRestaurant
//


import UIKit
import FirebaseAuth

class AddDataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addRestaurant(_ sendre: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func editRestaurant(_ sendre: UIButton) {
        
    }
    
    @IBAction func listOfRestaurant(_ sendre: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantListViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

    @IBAction func logoutRestaurant(_ sendre: UIButton) {
        do {
            try Auth.auth().signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            let navigation = UINavigationController(rootViewController: vc!)
            AppDelegate.shared.window?.rootViewController = navigation
            AppDelegate.shared.window?.makeKeyAndVisible()
        }
        catch {
            debugPrint(error.localizedDescription)
        }
    }
}
