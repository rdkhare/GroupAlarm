//
//  Settings.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/18/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Settings: UIViewController {
    
    override func viewDidLoad() {
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        try! Firebase.Auth.auth().signOut()
        
        let vc = UIStoryboard(name: "LoginAlarm", bundle: nil).instantiateViewController(withIdentifier: "loginAlarm") as? LoginAlarm
        self.view.window?.rootViewController = vc
        let userDefault = UserDefaults.standard
        
        userDefault.set(false, forKey: "loggedIn")
    }
    
    @IBAction func unwindToSettings(_ segue: UIStoryboardSegue){
        
    }
    
}
