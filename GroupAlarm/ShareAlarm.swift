//
//  ShareAlarm.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 8/4/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SVProgressHUD
import SafariServices

class ShareAlarm: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var shareEmail: UITextField!
    @IBOutlet weak var usersAddedTextField: UITextView!
    
    var sharedWith = [String]()
    
    var alarm: Alarm?
    
    override func viewDidDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "Share"
        
        self.shareEmail.returnKeyType = UIReturnKeyType.done
        
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        if(alarm?.key != nil) {
            
            ref.child("alarms").child((alarm?.key)!).child("userID").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let userIDs = snapshot.children
                
                while let userID = userIDs.nextObject() as? DataSnapshot {
                    if(userID.key != "0") {
                        
                        ref.child("users").child(userID.value! as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            let value = snapshot.value as? NSDictionary
                            let email = value?["email"] as? String
                            
                            self.usersAddedTextField.text = self.usersAddedTextField.text + "\n" + email!
                            
                            self.sharedWith.append(userID.value as! String)
                            
                            self.alarm?.members = self.sharedWith
                            
                        }, withCancel: { (error) in
                            
                        })
                    }
                }
                
            }) { (error) in
                
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ShareAlarm.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ShareAlarm.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        shareEmail.delegate = self
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    @IBAction func sendRequest(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.setRingThickness(1.0)
        self.view.endEditing(true)
        searchEmails()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.setRingThickness(1.0)
        searchEmails()
        return false
    }
    
    func searchEmails() {
        
        if self.shareEmail.text != "" && self.shareEmail.text?.isEmpty == false{
            
            Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: self.shareEmail.text!).observe(.value, with: {(Snapshot) in
                
                //                print(Snapshot.children.allObjects[0])
                
                if Snapshot.exists(){
                    
                    
                    let uniqueKey = Snapshot.children.allObjects[0] as! DataSnapshot
                    print(uniqueKey.key)
                    
                    if(uniqueKey.key != Auth.auth().currentUser?.uid) {
                        //                        let alarmIDRef = Database.database().reference().child("users").child(uniqueKey.key)
                        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)

                        if(self.usersAddedTextField.text.contains(self.shareEmail.text!)) {
                            SVProgressHUD.showError(withStatus: "You have shared with this person already.")
                        }
                            
                        else {
                            self.sharedWith.append(uniqueKey.key)
                            
                            self.usersAddedTextField.text = self.usersAddedTextField.text + "\n" + self.shareEmail.text!
                            
                            SVProgressHUD.showSuccess(withStatus: "Shared with \(self.shareEmail.text!).")
                        }
                    }
                    else {
                        
                    }
                    
                }
                else{
                    
                    SVProgressHUD.showError(withStatus: "No email found.")
                    
                }
                
                
            }, withCancel: {(error) in
                
                
            })
            
            
        }else{
            
            //Your textfield must not be empty;.... Handle that error
            SVProgressHUD.showError(withStatus: "Error. Please try again.")
            
        }
        
        SVProgressHUD.dismiss()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if(identifier == "unwindFromShare") {
                let destination = segue.destination as! AlarmInformation
                
                for people in sharedWith {
                    destination.sharedPeople.append(people)
                }
                destination.alarm = alarm
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    
}
