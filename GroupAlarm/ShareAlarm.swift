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
    
    override func viewDidLoad() {
        self.navigationItem.title = "Share"
        
        self.shareEmail.returnKeyType = UIReturnKeyType.done
                
        shareEmail.delegate = self
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
                        
                        self.sharedWith.append(uniqueKey.key)
                        
                        self.usersAddedTextField.text = self.usersAddedTextField.text + "\n" + self.shareEmail.text!
                        
                        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
                        SVProgressHUD.showSuccess(withStatus: "Shared with \(self.shareEmail.text!).")
                    }
                    else {
                        SVProgressHUD.showError(withStatus: "Cannot share alarm with yourself.")
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
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    
}
