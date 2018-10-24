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

class ViewController: UIViewController , GIDSignInUIDelegate   {
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var signInLable: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        }
        else {
            signInLable.text = "sign up"
            signInButton.setTitle("sign up", for: .normal)
            confirmPassTextField.isHidden=false
            confirmPassLable.isHidden=false
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
                            self.performSegue(withIdentifier: "goToHome", sender: self)
                        }
                    }
                }
            }
            else {
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
                            self.performSegue(withIdentifier: "goToHome", sender: self)
                        }
                    }
                }
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
    
}

