//
//  AppDelegate.swift
//  signIn
// change made
//  Created by Arwa Hamed on 15/01/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.
//

import UIKit

import Firebase
import GoogleUtilities
import GoogleSignIn


struct AdminInfo {
    static let email = "admin@admin.com"
}

@UIApplicationMain
//<<<<<<< HEAD
//class AppDelegate: UIResponder, UIApplicationDelegate  {

//=======
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
 
    
   
    
//>>>>>>> d31ff953c42ad85835b0d12222fa7fc96eae21a4
    var window: UIWindow?
    
    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Use Firebase library to configure APIs *GOOGLE*
        FirebaseApp.configure()
        
        //START google
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        //ENDgoogle
        
        //check
        if let isLogin = Auth.auth().currentUser {
            if isLogin.email == AdminInfo.email {
                
                window = UIWindow(frame: UIScreen.main.bounds)
                let vc = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "CategoryViewController")
                window?.rootViewController = UINavigationController(rootViewController: vc)
                window?.makeKeyAndVisible()
            }
            else{
                window = UIWindow(frame: UIScreen.main.bounds)
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
            }
        }

        return true
       
    }//end func application(_
    
    //START google
    //
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    //
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
   
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("An error occured during Google Authentication")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                 print("Google Authentification Fail")
                return
            }
            // User is signed in
            print("Google Authentification Success")
            //go to the home page
            self.window?.rootViewController!.performSegue(withIdentifier: "goToHome", sender: nil)

            
           /* let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let homePage = mainStoryBoard.instantiateViewController(withIdentifier: "goToHome") as! UITabBarController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homePage*/
            
            
            // Access the storyboard and fetch an instance of the view controller
           // let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
           //  let homePage = mainStoryBoard.instantiateViewController(withIdentifier: "goToHome") as! UIStoryboardSegue;
            
            // Then push that view controller onto the navigation stack
           // let rootViewController = self.window!.rootViewController as! UINavigationController;
           // rootViewController.pushViewController(homePage, animated: true);
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    
    

    //END google
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }        
    
}
