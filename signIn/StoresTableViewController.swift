//
//  StoresTableViewController.swift
//  signIn
//
//  Created by Arwa Hamed on 25/01/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn

class StoresTableViewController: UITableViewController , GIDSignInUIDelegate {

    
    
    //nwe
    
    let names = [ "Restaurants", "Coffee Shops & Bakeries" , "Perfumes and Beauty" ,
                  "Clothes" ,"Children Shops", "Sport" ,"Bags & Shoes","Accessories & Jewelry" ,
                  "Pharmacy & Optics" ,"Home"
        
                 ]
    
   // @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
    }
    
    ////////////////////////////// logout as user
    @objc func logout(){
        do {
            GIDSignIn.sharedInstance().signOut()
            try Auth.auth().signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
            AppDelegate.shared.window?.rootViewController = vc
            AppDelegate.shared.window?.makeKeyAndVisible()
        }
        catch {
            Helper.alert(title: "Sign out", messagee: error.localizedDescription, okTitle: "ok", okHandler: nil)
        }
    }
    //
    //

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNameControllerSegue" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let nameController = segue.destination as! SubTableViewController
               nameController.cellName = names[indexPath.row]
               // tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }

    
    
    
    
}


