//
//  LoginAlarm.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/18/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import FirebaseDatabase
import Firebase
import Canvas

class LoginAlarm: UIViewController, NVActivityIndicatorViewable, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var incorrectLabel: UILabel!
    
    @IBOutlet weak var animationView: CSAnimationView!
    @IBOutlet weak var loginButton: UIButton!
    
//    var alarms = Alarm()
    
    
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginAlarm.dismissKeyboard))
        
        self.incorrectLabel.isHidden = true

        self.username.keyboardType = UIKeyboardType.emailAddress
        
        view.addGestureRecognizer(tap)
        
        animationView.layer.cornerRadius = 4
        
        self.password.returnKeyType = UIReturnKeyType.continue
        
        self.username.delegate = self
        
        self.password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        createAccount(loginButton)
        return false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func createAccount(_ sender: Any) {
        Firebase.Auth.auth().createUser(withEmail: username.text!, password: password.text!) { (user, error) in
            if error != nil {
                
                let activityData = ActivityData()
                
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
                self.incorrectLabel.isHidden = false
                
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginAlarm.dismissKeyboard))
                
                self.view.addGestureRecognizer(tap)
                
                let anim = CAKeyframeAnimation(keyPath: "transform")
                anim.values = [
                    NSValue(caTransform3D:CATransform3DMakeTranslation(-5, 0, 0)),
                    NSValue(caTransform3D:CATransform3DMakeTranslation(5, 0, 0))
                ]
                anim.autoreverses = true
                anim.repeatCount = 2
                anim.duration = 10/100
                
                self.incorrectLabel.layer.add(anim, forKey: nil)
                
                print("incorrect")
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

            }
            else {
                
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginAlarm.dismissKeyboard))
                
                self.view.addGestureRecognizer(tap)
                
                let userDefault = UserDefaults.standard
                userDefault.set(true, forKey: "loggedIn")
                userDefault.synchronize()
                
                let ref : DatabaseReference!
                ref = Database.database().reference()
                
                let currentUserID = Auth.auth().currentUser?.uid
                
                ref.child("users").child(currentUserID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    print("\(snapshot)")
                    
                    let value = snapshot.value as? NSDictionary
                    
                    let userEmail = value?["email"] as? String
                    let username = value?["username"] as? String
                    
                    
                    if(userEmail == nil) {
                        ref.child("users").child(user!.uid).setValue(["email": self.username.text!])
                    }
                    if(username != nil) {
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alarmView") as? AlarmHandler
                        self.view.window?.rootViewController = vc

                    }
                    else {
                        let vc = UIStoryboard(name: "LoginAlarm", bundle: nil).instantiateViewController(withIdentifier: "createUsername") as? CreateUsername
                        
                        self.view.window?.rootViewController = vc
                        
                    }
                    
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
                
                
//                ref.child("users").child(user!.uid).setValue(["alarm": self.alarm])
                
                
                
                
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alarmView") as? AlarmHandler
//                self.show(vc!, sender: self)
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

            }
        }
    }
    
}
