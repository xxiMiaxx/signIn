//
//  NotificationViewController.swift
//  signIn
//
//  Created by Lamia Al salloom on 11/5/18.
//  Copyright © 2018 Arwa Hamed. All rights reserved.
//

import UIKit
import UserNotifications
class NotificationsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
            //   if()
            
        })
        let content = UNMutableNotificationContent()
        content.title = "Amazing Offers 50% off !"
        content.subtitle = "Sephora crazy offers for black friday !"
        content.body = ""
        content.badge = 1
        
        //define trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    //    @IBAction func action(_ sender: Any) {
    //        let content = UNMutableNotificationContent()
    //        content.title = "Amazing Offers 50% off !"
    //        content.subtitle = "Sephora crazy offers for black friday !"
    //        content.body = ""
    //        content.badge = 1
    //
    //        //define trigger
    //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
    //        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
    //        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    //    }
    
    //الصدقي
//    @IBAction func triggerNotifcation(_ sender: Any) {
//
//        let content = UNMutableNotificationContent()
//        content.title = "Amazing Offers 50% off !"
//        content.subtitle = "Sephora crazy offers for black friday !"
//        content.body = ""
//        content.badge = 1
//
//        //define trigger
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//    }
    
    
    
    /*
     // MARK: - Navigation
     
     @IBOutlet weak var TriggerNotifcations: UITabBarItem!
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

