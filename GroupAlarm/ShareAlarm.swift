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
    
    override func viewDidLoad() {
        self.navigationItem.title = "Share"
        
        self.shareEmail.returnKeyType = UIReturnKeyType.done
                
        shareEmail.delegate = self
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
                
                let uniqueKey = Snapshot.children.allObjects[0] as! DataSnapshot
                print(uniqueKey.key)

                
//                print(Snapshot.children.allObjects[0])
                
                if Snapshot.exists(){
                    
                    // The email that you have been searching for exists in the
                    // database under some particular userID node which can
                    // be retrieved from ....
                    
                    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
                    
                    
                    
                    SVProgressHUD.showSuccess(withStatus: "Request sent to \(self.shareEmail.text!).")
                    
                    self.usersAddedTextField.text = self.usersAddedTextField.text + "\n" + self.shareEmail.text!
                    
//                    print(Snapshot)
                    
                    
                }else{
                    
                    // No such email found
                    
                    SVProgressHUD.showError(withStatus: "No email found.")
                    
                }
                
                
            }, withCancel: {(error) in
                
                // Handle any error occurred while making the call to firebase
                
            })
            
            
        }else{
            
            //Your textfield must not be empty;.... Handle that error
            SVProgressHUD.showError(withStatus: "Error. Please try again.")

        }
        
        SVProgressHUD.dismiss()
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    
}
