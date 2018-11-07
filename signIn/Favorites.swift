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
    
    var posts = [Post]()
    var cellName = String()
    var SubTable:SubTableViewController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
        //Lable from storyboard
        
        
        var cellLabel: UILabel!
        //cellLabel = UILabel(frame: CGRectMake(self.tableView.frame.width - 100, 10, 100.0, 40))
        cellLabel = UILabel(frame: CGRect(x: 150, y: 0, width: self.tableView.frame.width, height: 20))
        cellLabel.textColor = UIColor.red
        cellLabel.text="Arwa"
       
      // tableView.addSubview(UIStoryboard)
      
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        tableView.reloadData()
       //let favPosts = [Post]()
        //self.posts = favPosts
        //observePosts(tempPosts: SubTable?.Favorites?.posts ?? favPosts )
        //tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        //cell.link = self
        cell.set(post: self.posts[indexPath.row])
        return cell
        
        
    }
    
    func observePosts(tempPosts:[Post]){
        
        self.posts = tempPosts
        self.tableView.reloadData()
        
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
                      //print("userID")
                      //print(userID)
                      //print("currentUserID")
                      //print(currentUserID)
                    
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
