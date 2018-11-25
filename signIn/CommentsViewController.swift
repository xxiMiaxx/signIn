//
//  CommentsViewController.swift
//  signIn
//
//  Created by Arwa Hamed on 15/03/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CommentsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var link:SubTableViewController?
    var navigationItemTitle:String?
    var tableView:UITableView!
    var link2: NewPostViewController?
    var text: String? = nil
    

    var comments = [Comment] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        
        let cellNib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "commentCell")
        tableView.backgroundColor = UIColor(white: 0.90,alpha:1.0)
        view.addSubview(tableView)
        
        var layoutGuide:UILayoutGuide!
        
        if #available(iOS 11.0, *) {
            layoutGuide = view.safeAreaLayoutGuide
        } else {
            // Fallback on earlier versions
            layoutGuide = view.layoutMarginsGuide
        }
        
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        //tableView.tableHeaderView?.accessibilityIdentifier = "Comments"
        //self.navigationItem.prompt = "COMMENTS"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        observePosts()
        tableView.reloadData()
        tableView.allowsSelection=false
        
    }
    
    @IBAction func handleLogout(_ sender:Any) {
        try! Auth.auth().signOut()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        cell.set(comment: comments[indexPath.row])
        return cell
    }

    @IBAction func handleAddCommentBtn(_ sender: Any) {
    
       self.performSegue(withIdentifier: "AddCommentPage2", sender:self)
        GlobalVariables.sharedManager.myName = self.navigationItem.title!
       
    }
    
    @IBAction func handelAddBtn() {
       // link2!.storeName = self.navigationItemTitle
        print("link2!.storeName")
        //print(link2!.storeName)
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddComment") as! NewPostViewController
       self.present(newViewController, animated: true, completion: nil)
    
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let NewPostViewController = segue.destination as? NewPostViewController{
            NewPostViewController.storeName = self.navigationItem.title
           // print(NewPostViewController.storeName)
             print("NewPostViewController.storeName")
        }
    }
    
    
    func observePosts(){
        
        
        
        let reviewsRef = Database.database().reference().child("reviews")
        
        
        reviewsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var tempComment = [Comment]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let author = dict["author"] as? [String:Any],
                    let username = author["username"] as? String,
                    let uid = author["uid"] as? String,
                    let text = dict["text"] as? String,
                    let storeName = dict["storeName"] as? String,
                    let timestamp = dict["timestamp"] as? String {
                    if self.navigationItem.title == storeName {
                    
                    let userProfile = UserProfile(uid: uid, userName: username, email: "", password: "")
                    let comment = Comment(id: childSnapshot.key, author: userProfile, text: text, timestamp:timestamp)
                     tempComment.append(comment)
                }
              }
            }
            
            self.comments = tempComment
            self.tableView.reloadData()
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observePosts()
        
    }
    
}
