//
//  OffersTableViewController.swift
//  signIn
//
//  Created by Shahad Z on 14/02/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import Foundation
import FirebaseDatabase
class OffersTableViewController: UITableViewController  {
        let ref = Database.database().reference()
    
     var offers = [offer]()
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observePosts()
   
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        
        
        let cellNib = UINib(nibName: "OffersTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "shahadz")
        
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
        
      
             tableView.reloadData()
    
        
        
    }
    
 
    

    
    
    
    func observePosts(){
        
        let postRef = Database.database().reference().child("Offers")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var tempoffers = [offer]()
            for child in snapshot.children {
                if  let childSnapshot = child as? DataSnapshot ,
                   let key = childSnapshot.key as? String ,
                    let dict = childSnapshot.value as? [String:Any] ,
                    let photoURL = dict["photoURL"] as? String ,
                    let Edate: String = dict["Edate"]as? String ,
                 
                    let url = URL(string:photoURL) {
                    let offer1 = offer(  photoURL: url )
                 
            
                   
    //delet auto
                    let indexOfDay = Edate.index(of: "/")!
                    let dataDay = Edate[..<indexOfDay ]
                 
                    let  indexOfYear = Edate.lastIndex(of: "/")!
                
                 
                    let temp = Edate[..<indexOfYear ]
                    let datamonth = temp[indexOfDay...].replacingOccurrences(of: "/", with: "")
                    
                    let dataYear=Edate.substring(from:indexOfYear).replacingOccurrences(of: "/", with:"")
                    let day : Int = Int(dataDay)!
                    let month:Int = Int(datamonth)!
                    let year : Int = Int(dataYear)!
                  
                    
                 
                       print("--------------------------------------------------")
                      print(day)
                      print(month)
                      print(year)
                      print("--------------------------------------------------")
                    let date = Date()
                    let calender = Calendar.current
                    
                    let Currentyear:Int = calender.component(.year, from: date)
                    var CurrentMonth:Int = calender.component(.month, from: date)
                    var CurrentDay:Int = calender.component(.day, from: date)
             
                    
                  
                       
                        if(year<Currentyear){
                            self.ref.child("Offers").child(key).removeValue()
                            
                           self.observePosts();
                            
                            print("--------------------------------------------------")
                            print("shahad")
                            
                        }
                        
                        if(Currentyear==year && month<CurrentMonth){
                           self.ref.child("Offers").child(key).removeValue()
                           self.observePosts();
                            
                        }
                        
                        if(Currentyear==year && CurrentMonth==month  && day<CurrentDay )  {
                            self.ref.child("Offers").child(key).removeValue()
                           self.observePosts();
                        }
                        
                        if(Currentyear<year && month<CurrentMonth )  {
                            self.ref.child("Offers").child(key).removeValue()
                           self.observePosts();
                        }
                   
                
                   
                   
                    
                        tempoffers.append(offer1)
                    
                    
                }
                
                
               
               
            }
            
            self.offers =  tempoffers
            self.tableView.reloadData()
            
        })
     
        
        
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shahadz", for: indexPath) as! OffersTableViewCell
        
        cell.set(offer: self.offers[indexPath.row])
        return cell
        
    }
    
    
    
}
