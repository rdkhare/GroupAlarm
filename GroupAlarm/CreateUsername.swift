//
//  CreateUsername.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 8/1/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import Canvas
import NVActivityIndicatorView

class CreateUsername: UIViewController, NVActivityIndicatorViewable, UITextFieldDelegate {
    
    @IBOutlet weak var createUsernameText: UITextField!
    
    @IBOutlet weak var incorrectUsername: UILabel!
    
    @IBOutlet weak var usernameView: CSAnimationView!
    @IBOutlet weak var createButton: UIButton!
    
    var alarm: Alarm?
    
    var usernameUnique: Bool? = true
    
    func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= 40
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += 40
        }
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        try! Firebase.Auth.auth().signOut()
        
        let vc = UIStoryboard(name: "LoginAlarm", bundle: nil).instantiateViewController(withIdentifier: "loginAlarm") as? LoginAlarm
        self.view.window?.rootViewController = vc
        let userDefault = UserDefaults.standard
        
        userDefault.set(false, forKey: "loggedIn")
    }
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateUsername.dismissKeyboard))
        
        self.incorrectUsername.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateUsername.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateUsername.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        view.addGestureRecognizer(tap)
        
        usernameView.layer.cornerRadius = 4
        
        
        self.createUsernameText.returnKeyType = UIReturnKeyType.go
        self.createUsernameText.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        createUsername(createButton)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        
        if (string == " ") {
            
            incorrectUsername.text = "Please create a username without spaces."
            incorrectUsername.isHidden = false
            
            return false
        }
        let maxLength = 12
        let currentString: NSString = createUsernameText.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if(newString.length == maxLength) {
            incorrectUsername.isHidden = false
            incorrectUsername.text = "Characters are limited to 12 for the username."
        }
        
        return newString.length <= maxLength
    }
    
    @IBAction func createUsername(_ sender: Any) {
        
        let currentUserID = Auth.auth().currentUser?.uid
        
        let ref : DatabaseReference!
        ref = Database.database().reference()
        
        if(self.createUsernameText.text?.isEmpty)! {
            self.incorrectUsername.text = "Please enter in a username."
            self.incorrectUsername.isHidden = false
        }
        
        if((self.createUsernameText.text?.characters.count)! < 3) {
            self.incorrectUsername.text = "Please enter at least 4 characters for your username."
            self.incorrectUsername.isHidden = false
        }
        else {
            ref.child("users").child(currentUserID!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                let username = value?["username"] as? String
                
                if username == nil{
                    
                    
                    ref.child("users").child(currentUserID!).updateChildValues(["username": self.createUsernameText.text?.lowercased() as Any])
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alarmView") as? AlarmHandler
                    
                    self.view.window?.rootViewController = vc
                    
                }
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            
        }
        
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
