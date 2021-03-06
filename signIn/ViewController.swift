//
//  ViewController.swift
//  signIn
//zg
//  Created by Arwa Hamed on 15/01/1440 AH.
//  Copyright © 1440 Arwa Hamed. All rights reserved.

import UIKit
import Firebase
import FirebaseAuth
import Firebase
import GoogleSignIn

class ViewController: UIViewController , GIDSignInUIDelegate ,UITextFieldDelegate  {
    
    
    var userNameArray = [String]()
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var signInLable: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var confirmPassLable: UILabel!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var isSignIn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //google
        
       GIDSignIn.sharedInstance().uiDelegate = self
      // GIDSignIn.sharedInstance().signIn()
        
        
        //google
        
        confirmPassTextField.isHidden=true
        confirmPassLable.isHidden=true
        userName.isHidden=true
        userNameTextField.isHidden=true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInSelctorChanged(_ sender: UISegmentedControl) {
        
        isSignIn = !isSignIn
        
        if isSignIn {
            signInLable.text = "sign In"
            signInButton.setTitle("Sign In", for: .normal)
            confirmPassTextField.isHidden=true
            confirmPassLable.isHidden=true
            userName.isHidden=true
            userNameTextField.isHidden=true
        }
        else {
            signInLable.text = "sign up"
            signInButton.setTitle("sign up", for: .normal)
            confirmPassTextField.isHidden=false
            confirmPassLable.isHidden=false
            userName.isHidden=false
            userNameTextField.isHidden=false
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text,let pass = passwordTextField.text {
            
            if isSignIn {
                
                Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
                    
                    if let firebaseError = error {
                        let s = firebaseError.localizedDescription
                        if  s == "There is no user record corresponding to this identifier. The user may have been deleted."{
                            let alert = UIAlertController(title: "", message: " you are not registered please sign up to start a greate journey ", preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                print("Action")
                                
                            })
                            alert.addAction(action1)
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        else if s == "The password is invalid or the user does not have a password." {
                            let alert = UIAlertController(title: "", message: "incorrect password ", preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                print("Action")
                                
                            })
                            alert.addAction(action1)
                            self.present(alert, animated: true, completion: nil)
                            return
                            
                        }
                        else{
                            let alert = UIAlertController(title: "", message: firebaseError.localizedDescription, preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                print("Action")
                                
                            })
                            alert.addAction(action1)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    else {
                        
                        guard let user = authResult?.user else { return }
                        if user.email == AdminInfo.email {
                            self.performSegue(withIdentifier: "showAdminHome", sender: self)
                        }
                        else{
                           // Auth.auth().createUser(withEmail: email, password: pass)
                            //self.saveProfile(email: email , password:pass)
                            self.performSegue(withIdentifier: "goToHome", sender: self)
                        }
                    }
                }
            }
            else {
               var userNameText = userNameTextField.text
                var wasExist = isExist(userNameText: userNameText!)
                
                if wasExist {
                    print ("exist")
                    let alert = UIAlertController(title: "", message: "Sorry , that username already exist!", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        print("Action")
                    })
                    alert.addAction(action1)
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                else {//
                   print ("not exist")
                
                
                if pass != self.confirmPassTextField.text {
                    let alert = UIAlertController(title: "", message: "Your password and confirmation passwoed do not match ", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        print("Action")
                    })
                    alert.addAction(action1)
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                
                Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
                    
                    if let firebaseError=error {
                        let alert = UIAlertController(title: "", message: firebaseError.localizedDescription, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            print("Action")
                            
                        })
                        alert.addAction(action1)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    else {
                        
                        guard let user = authResult?.user else { return }
                        if user.email == AdminInfo.email {
                            self.performSegue(withIdentifier: "showAdminHome", sender: self)
                        }
                        else{
                            self.saveProfile(email: email , password:pass , userNameText:userNameText!)
                            self.performSegue(withIdentifier: "goToHome", sender: self)
                        }
                    }
                }
                }//
           }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func CallSecurity(_ sender: Any) {
    
        let url: NSURL = URL(string: "TEL://00966920009467")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    
    }
    
    
    //Save user
    func saveProfile(email:String, password: String, userNameText: String)  {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "email": email,
            "password": password,
            "userName": userNameText
            ] as [String:Any]
        
        ///
        var userNameText = userNameTextField.text
        var wasExist = isExist(userNameText: userNameText!)
        
        if wasExist {
            print ("exist")
            let user = Auth.auth().currentUser
            
            user?.delete { error in
                if let error = error {
                    // An error happened.
                } else {
                    // Account deleted.
                }
            }
         
            let alert = UIAlertController(title: "", message: "Sorry , that username already exist!", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                print("Action")
            })
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        else {//
        
        databaseRef.setValue(userObject) { error, ref in
        
        }
        }
        
       
    }
    func isExist(userNameText: String) ->Bool{
        var wasExist = Bool()
        //////user Name START
        print("END")
        print(self.userNameArray.count)
        
        print("START1")
        let users = Database.database().reference().child("users/profile")
        print("START2")
        users.observe(.value, with: { (snapshot) in
            print("START3")
            var userNames = [String]()
            
            print("STAR4")
            for child in snapshot.children {
                if  let childSnapshot = child as? DataSnapshot ,
                    let dict = childSnapshot.value as? [String:Any] ,
                    let userName = dict["userName"] as? String{
                    userNames.append(userName)
                    print("userName")
                    print(userName + "1")
                }
            }
            self.userNameArray=userNames
        })
        
        for name in self.userNameArray {
            print("AARRWWAA")
            print(name)
            if name.isEqual(userNameText){
                wasExist = true
                print("name")
                print(name)
                break
            } else {
                wasExist = false
                print("name")
                print(name)
            }
            
        }
        
        return wasExist
        ///////user Name END
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.emailTextField.delegate = self
        self.confirmPassTextField.delegate=self
        self.passwordTextField.delegate = self
        self.userNameTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
}

