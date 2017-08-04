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

class ShareAlarm: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var shareEmail: UITextField!
    
    override func viewDidLoad() {
        self.navigationItem.title = "Share"
        
        self.shareEmail.returnKeyType = UIReturnKeyType.done
        
        shareEmail.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        searchEmails()
        
        return false
    }
    
    func searchEmails() {
        var ref : DatabaseReference
        let currentUserID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        let userRef = ref.child("users").child(currentUserID!)
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                if(rest.key == "email") {
                    
                    if((rest.value as? String) == self.shareEmail.text) {
                        
                    }
                    else {
                        print("Email is not correct")
                    }
                    
                    print(rest.value!)
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    
}
