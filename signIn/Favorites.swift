//
//  Favorites.swift
//  signIn
//
//  Created by Arwa Hamed on 28/02/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
class Favorites : UITableViewController {

    @IBOutlet weak var pageTitle: UINavigationItem!
    var posts = [Post]()
    var cellName = String()
    var link:SubTableViewController?
 
    
    
    func someMethodIWantToCallDelete(cell: UITableViewCell) {
       
        let indexPathTapped = tableView.indexPath(for: cell)
        
        let selectedName = posts[indexPathTapped!.row].name as!String
        
        let favRef = Database.database().reference().child("users/favList")
        favRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let currentUserID = Auth.auth().currentUser?.uid
            
            for child in snapshot.children {
                if  let childSnapshot = child as? DataSnapshot ,
                    let dict = childSnapshot.value as? [String:Any] ,
                    let userID = dict["userID"] as? String ,
                    let name = dict["name"] as? String ,
                    let photoURL = dict["photoURL"] as? String ,
                    let url = URL(string:photoURL) {
                    if userID == currentUserID && name==selectedName {
                        let childRef = childSnapshot.ref
                        childRef.removeValue()
                        self.observePosts1()
                        self.link?.observePosts()
                        
                        
                    }
                }
            }
            
            
            
        })
        print("End")
    }// end
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
        
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        let cellNib = UINib(nibName: "PostTableViewCellFav", bundle: nil)
         self.tableView.register(cellNib, forCellReuseIdentifier: "Fav")
       
        
        var layoutGuide:UILayoutGuide!
        layoutGuide=view.safeAreaLayoutGuide
        
        
         self.tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
         self.tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
         self.tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
         self.tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        
        //Lable from storyboard
        
        
        var cellLabel: UILabel!
        cellLabel = UILabel(frame: CGRect(x: 150, y: 0, width: self.tableView.frame.width, height: 20))
        cellLabel.textColor = UIColor.red
        cellLabel.text="Arwa"
       
     
      
        self.tableView.delegate = self
         self.tableView.dataSource = self
        
         self.tableView.tableFooterView = UIView()
         self.tableView.reloadData()
    
         observePosts1()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observePosts1()
        
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
        let cell =  self.tableView.dequeueReusableCell(withIdentifier: "Fav", for: indexPath) as! PostTableViewCellFav
        cell.Link = self
        cell.set(post: self.posts[indexPath.row])
        return cell
        
        
    }
    

    
    
    func observePosts1(){
        
        
    
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
                    if userID == currentUserID {
                      let post = Post(name: name , photoURL: url , phone:  phone ,loc:loc)
                      tempPosts.append(post)
                    }
                }
            }
            
            self.posts = tempPosts
            self.tableView.reloadData()
            
            
        })
        
        
    }
    
    
}
