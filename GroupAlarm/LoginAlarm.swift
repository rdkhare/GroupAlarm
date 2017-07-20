//
//  LoginAlarm.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/18/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import NVActivityIndicatorView
import FirebaseDatabase

class LoginAlarm: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    var alarms = Alarm()
    
    override func viewDidLoad() {
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func createAccount(_ sender: Any) {
        Firebase.Auth.auth().createUser(withEmail: username.text!, password: password.text!) { (user, error) in
            if error != nil {
                
                let activityData = ActivityData()
                
                NVActivityIndicatorView.DEFAULT_COLOR = UIColor.blue
                NVActivityIndicatorView.DEFAULT_TYPE = .ballPulse
                
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
                
                
                self.login()
                
            }
            else {
                
                
                
                print("User created.")
                self.login()
            }
            
        }
    }
    
    func login() {
        Firebase.Auth.auth().signIn(withEmail: username.text!, password: password.text!) { (user, error) in
            
            if(error != nil) {
                print("incorrect")
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

            }
            else {
                
                let userDefault = UserDefaults.standard
                userDefault.set(true, forKey: "loggedIn")
                userDefault.synchronize()
                
                let ref : DatabaseReference!
                ref = Database.database().reference()
                
                ref.child("users").child(user!.uid).setValue(["email": self.username.text!])
//                ref.child("users").child(user!.uid).setValue(["alarm": self.alarm])
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alarmView") as? AlarmHandler
                self.show(vc!, sender: self)
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

            }
        }
    }
    
}
