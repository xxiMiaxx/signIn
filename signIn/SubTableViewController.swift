//
//  SubTableViewController.swift
//  signIn
//
//  Created by Arwa Hamed on 25/01/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SubTableViewController: UITableViewController {
    
    //Fav
    
    //var Favorites:Favorites?
    var link: PostTableViewCell?
    var link2: CommentsViewController?
    var selectedCell:String?
    func someMethodIWantToCall(cell: UITableViewCell) {
       
        let indexPathTapped = tableView.indexPath(for: cell)
     
       let name = posts[indexPathTapped!.row].name as!String
       let loc = posts[indexPathTapped!.row].loc as!String
       let photoURL = posts[indexPathTapped!.row].photoURL.absoluteString as!String
       let phone = posts[indexPathTapped!.row].phone as!String
          let userID = Auth.auth().currentUser?.uid
        let favObject = [
            //"userID":userID,
            "userID":userID ,
            "name": name,
            "loc": loc,
            "photoURL":photoURL,
            "phone":phone
            ]
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/favList").childByAutoId()
        databaseRef.setValue(favObject)
       
        
    }
    
    func someMethodIWantToCallDelete(cell: UITableViewCell) {
        
        let indexPathTapped = tableView.indexPath(for: cell)
        
        let selectedName = posts[indexPathTapped!.row].name as!String
        
        let favRef = Database.database().reference().child("users/favList")
        favRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var tempPosts = [Post]()
            let currentUserID = Auth.auth().currentUser?.uid
            
            for child in snapshot.children {
                if  let childSnapshot = child as? DataSnapshot ,
                    let dict = childSnapshot.value as? [String:Any] ,
                    let userID = dict["userID"] as? String ,
                    let name = dict["name"] as? String ,
                    let photoURL = dict["photoURL"] as? String ,
                    let loc = dict["loc"] as? String ,
                    let phone = dict["phone"] as? String ,
                    let url = URL(string:photoURL) {
                    if userID == currentUserID && name==selectedName {
                     let childRef = childSnapshot.ref
                        childRef.removeValue()
                        
                    }
                }
            }
            
            
            
        })
        
    }// end
    

    @IBOutlet weak var categoryName: UINavigationItem!
    var posts = [Post]()
    var cellName = String()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryName.title = cellName
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        
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
        //tableView.allowsSelection=false
        observePosts()
        tableView.reloadData()
       // tableView.allowsSelection = falseh
       
        
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
        cell.link = self

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
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observePosts()
        tableView.reloadData()
    }
   
    func observePosts(){
        
        print("Start2")
        
        let postRef = Database.database().reference().child(cellName)
        
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var tempPosts = [Post]()
            
             print("Start3")
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
            
            print("Start4")
        })
        
    }
    

    @IBAction func SearchBut(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "SearchFuncTableViewController") as! SearchFuncTableViewController
        myVC.StringPassed = cellName
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    
//new
    //to grab a row, update your did select row at index path method to:
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.selectedCell = posts[indexPath.row].name as!String
       // print(self.selectedCell)
        self.selectedCell = posts[indexPath.row].name
        link2?.navigationItemTitle =  self.selectedCell
        print(self.selectedCell as Any)
        
        let title = self.selectedCell! + " " + "Reviews"
            let myVC = storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! CommentsViewController
            myVC.navigationItem.title =  title
            navigationController?.pushViewController(myVC, animated: true)
            //self.performSegue(withIdentifier: "goToCommentsPage", sender: self)
        
    }
    
    
    
}
