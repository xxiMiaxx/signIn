//
//  SubTableViewController.swift
//  signIn
//
//  Created by Arwa Hamed on 25/01/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SubTableViewController: UITableViewController {

    @IBOutlet weak var categoryName: UINavigationItem!
    var posts = [Post]()
    var cellName = String()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryName.title = cellName
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //
        //new
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        // tableView.backgroundColor = UIColor.blue
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        
        //view.addSubview(tableView)
        // tableView.addSubview(tableView)
        
        
        
        
        var layoutGuide:UILayoutGuide!
        layoutGuide=view.safeAreaLayoutGuide
        
        
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
        observePosts()
        tableView.reloadData()
        
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.posts.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        cell.set(post: self.posts[indexPath.row])
        return cell
        
        
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    func observePosts(){
        
        
        
        let postRef = Database.database().reference().child(cellName)
        
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var tempPosts = [Post]()
            
            
            for child in snapshot.children {
                if  let childSnapshot = child as? DataSnapshot ,
                    let dict = childSnapshot.value as? [String:Any] ,
                   // let type = dict["Type"] as? String ,
                    let name = dict["name"] as? String ,
                    let photoURL = dict["photoURL"] as? String ,
                    let loc = dict["loc"] as? String ,
                    let phone = dict["phone"] as? String ,
                    let url = URL(string:photoURL) {
                    let post = Post(name: name , photoURL: url , phone:  phone ,loc:loc)
                    tempPosts.append(post)
                }
            }
            
            self.posts = tempPosts
            self.tableView.reloadData()
            
            
        })
        
    }
    

    @IBAction func SearchBut(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "SearchFuncTableViewController") as! SearchFuncTableViewController
        myVC.StringPassed = cellName
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    

}
