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
import MessageUI

class ShareAlarm: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var countUsersLabel: UILabel!
    @IBOutlet weak var shareEmail: UITextField!
    @IBOutlet weak var usersAddedTextField: UITextView!
    
    var sharedWith = [String]()
    var newAlarmKey: String?
    var alarm: Alarm?
    var sharedIDs = [String]()
    
    override func viewDidDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "Share"
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareAlarm.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        self.shareEmail.returnKeyType = UIReturnKeyType.done
        
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        if(!sharedIDs.isEmpty) {
            if(self.sharedIDs.count == 1) {
                self.countUsersLabel.text = "Shared with \(self.sharedIDs.count) user."
            }
            else {
                self.countUsersLabel.text = "Shared with \(self.sharedIDs.count) users."
            }
            
            for person in sharedIDs {
                
                ref.child("users").child(person).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    let email = value?["email"] as? String
                    
                    self.usersAddedTextField.text = self.usersAddedTextField.text + "\n" + email!
                    
                })
                
            }
            
        }
        
        else if(alarm?.key! != nil) {
            
            ref.child("alarms").child((alarm?.key)!).child("userID").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let userIDs = snapshot.children
                
                print(snapshot)
                
                while let userID = userIDs.nextObject() as? DataSnapshot {
                    if(userID.key != "0") {
                        
                        ref.child("users").child(userID.value! as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            let value = snapshot.value as? NSDictionary
                            let email = value?["email"] as? String
                            
                            self.usersAddedTextField.text = self.usersAddedTextField.text + "\n" + email!
                            
                            self.sharedWith.append(userID.value as! String)
                            
                            if(self.sharedWith.count == 1) {
                                self.countUsersLabel.text = "Shared with \(self.sharedWith.count) user."
                            }
                            else {
                                self.countUsersLabel.text = "Shared with \(self.sharedWith.count) users."
                            }
                            
                            self.alarm?.members = self.sharedWith
                            
                        }, withCancel: { (error) in
                            
                        })
                    }
                }
                
            }) { (error) in
                
            }
        }
        else {
            
            if(self.sharedWith.count == 1) {
                self.countUsersLabel.text = "Shared with \(self.sharedWith.count) user."
            }
            else {
                self.countUsersLabel.text = "Shared with \(self.sharedWith.count) users."
            }
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(ShareAlarm.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(ShareAlarm.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        shareEmail.delegate = self
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height - 100
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height + 100
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func configuredMailComposeViewController(recipient: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([recipient])
        mailComposerVC.setSubject("Share Alarm Request - GroupAlarm")
        mailComposerVC.setMessageBody("Hi, \n \n I would like to share an alarm with you. \n Download GroupAlarm on the App Store now at http://app2.it/groupalarm. \n Thanks!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Cannot send email.", message: "An error has occurred. Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if(result == MFMailComposeResult.sent) {
            self.usersAddedTextField.text = self.usersAddedTextField.text + "\n" + self.shareEmail.text!
        }
        
        controller.dismiss(animated: true, completion: nil)
        
        self.shareEmail.text = ""
    }
    
    func searchEmails() {
        
        if self.shareEmail.text != "" && self.shareEmail.text?.isEmpty == false{
            
            Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: self.shareEmail.text!).observe(.value, with: {(Snapshot) in
                
                if Snapshot.exists(){
                    
                    
                    let uniqueKey = Snapshot.children.allObjects[0] as! DataSnapshot
                    print(uniqueKey.key)
                    
                    if(uniqueKey.key != Auth.auth().currentUser?.uid) {
                        
                        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)

                        if(self.usersAddedTextField.text.contains(self.shareEmail.text!)) {
                            
                        }
                            
                        else {
                            self.sharedWith.append(uniqueKey.key)
                            
                            self.usersAddedTextField.text = self.usersAddedTextField.text + "\n" + self.shareEmail.text!
                            
                            SVProgressHUD.showSuccess(withStatus: "Shared with \(self.shareEmail.text!).")
                            
                            if(self.sharedWith.count == 1) {
                                self.countUsersLabel.text = "Shared with \(self.sharedWith.count) user."
                            }
                            else {
                                self.countUsersLabel.text = "Shared with \(self.sharedWith.count) users."
                            }
                        }
                    }
                    else {
                        
                    }
                    
                }
                else{
                    
                    if(self.isValidEmail(testStr: self.shareEmail.text!)) {
                        let alert = UIAlertController(title: "Send email to recipient?", message: "Press send if you would like to send an email to this person to share future alarms.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        
                        
                        alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.default, handler: { action in
                            
                            let mailComposeViewController = self.configuredMailComposeViewController(recipient: "\(self.shareEmail.text!)")
                            if MFMailComposeViewController.canSendMail() {
                                self.present(mailComposeViewController, animated: true, completion: nil)
                            } else {
                                self.showSendMailErrorAlert()
                            }
                            
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    else {
                        SVProgressHUD.showError(withStatus: "Error. Not a valid email.")
                    }
                    
                }
                
                
            }, withCancel: {(error) in
                
                
            })
            
            
        }else{
            
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
