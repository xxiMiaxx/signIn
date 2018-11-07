//
//  StoreTableViewController.swift
//  signIn
//
//  Created by Arwa Hamed on 23/01/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import UIKit
import FirebaseDatabase


class StoreViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    

    

    
    //new
    var tableView:UITableView!
    
    var posts = [Post]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //
        //new
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .plain)
        
       // tableView.backgroundColor = UIColor.blue
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        
        view.addSubview(tableView)
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
    
    //new
    
    func observePosts(){
        
        let postRef = Database.database().reference().child("Restaurants")
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var tempPosts = [Post]()
            for child in snapshot.children {
        if  let childSnapshot = child as? DataSnapshot ,
                let dict = childSnapshot.value as? [String:Any] ,
                let name = dict["name"] as? String ,
                let photoURL = dict["photoURL"] as? String ,
                let loc = dict["Gate"] as? String ,
                let phone = dict["phone"] as? String ,
            
                let url = URL(string:photoURL) {
            let post = Post(name: name  ,   photoURL: url , phone:  phone , loc:loc)
                tempPosts.append(post)
                }
            }
            
            self.posts = tempPosts
            self.tableView.reloadData()
                
       })
        
  }
        
    
    

    
    //new
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        cell.set(post: self.posts[indexPath.row])
        return cell
        
        
    }
    

}
