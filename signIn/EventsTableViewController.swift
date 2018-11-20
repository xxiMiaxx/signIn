//
//  EventsTableViewController.swift
//  signIn
//
//  Created by Shahad Z on 10/02/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import UIKit
import FirebaseDatabase
import UserNotifications

class EventsTableViewController: UITableViewController  {
        let ref = Database.database().reference()
 //   var tableView:UITableView!
    var events = [event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
          super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        
        
        let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "shahad")
        
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
        tableView.allowsSelection=false
        observePosts()
        tableView.reloadData()
        
        
        //====
        //Notifcation
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
            //   if()
            
        })
        let content = UNMutableNotificationContent()
        content.title = "Exclusive Events & Offers just for you"
        content.subtitle = "Check out Riyadh Park amazing events !"
        content.body = ""
        content.badge = 1
        
        //define trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
    }
    
    func observePosts(){
        
        let postRef = Database.database().reference().child("Events")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var tempEvents = [event]()
            for child in snapshot.children {
                if  let childSnapshot = child as? DataSnapshot ,
                    let dict = childSnapshot.value as? [String:Any] ,
                      let key = childSnapshot.key as? String ,
                    let desc = dict["desc"] as? String ,
                      let Edate: String = dict["Edate"]as? String ,
                    let photoURL = dict["photoURL"] as? String ,
                   
                    let url = URL(string:photoURL) {
                    let event1 = event( desc:desc, photoURL: url )
                    tempEvents.append(event1)
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
                        self.ref.child("Events").child(key).removeValue()
                        self.observePosts();
                        
                        
                        
                        print("--------------------------------------------------")
                        print("shahad")
                        
                    }
                    
                    if(Currentyear==year && month<CurrentMonth){
                        self.ref.child("Events").child(key).removeValue()
                        self.observePosts();
                        
                        
                    }
                    
                    if(Currentyear==year && CurrentMonth==month  && day<CurrentDay )  {
                        self.ref.child("Events").child(key).removeValue()
                               self.observePosts();
                    }
                    
                    if(Currentyear<year && month<CurrentMonth )  {
                        self.ref.child("Events").child(key).removeValue()
                               self.observePosts();
                    }
                    
                    
                 
                
                }}
            
            self.events = tempEvents
            self.tableView.reloadData()
            
        })
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shahad", for: indexPath) as! TableViewCell
        
        cell.set(event: self.events[indexPath.row])
        return cell
        
    }
}
