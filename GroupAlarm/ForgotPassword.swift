//
//  ForgotPassword.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 8/22/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class ForgotPassword: UIViewController {
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var incorrectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.incorrectLabel.isHidden = true
        self.emailInput.keyboardType = UIKeyboardType.emailAddress

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginAlarm.dismissKeyboard))
        
        self.view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        if(isValidEmail(testStr: self.emailInput.text!) && !(self.emailInput.text?.isEmpty)!) {
            Auth.auth().sendPasswordReset(withEmail: self.emailInput.text!) { error in
                if(error != nil) {
                    let anim = CAKeyframeAnimation(keyPath: "transform")
                    anim.values = [
                        NSValue(caTransform3D:CATransform3DMakeTranslation(-5, 0, 0)),
                        NSValue(caTransform3D:CATransform3DMakeTranslation(5, 0, 0))
                    ]
                    anim.autoreverses = true
                    anim.repeatCount = 2
                    anim.duration = 10/100
                    
                    self.incorrectLabel.layer.add(anim, forKey: nil)
                    self.incorrectLabel.text = "Email not found."
                    self.incorrectLabel.isHidden = false
                }
                else {
                    SVProgressHUD.showSuccess(withStatus: "Email sent to \(self.emailInput.text!)")
                }
            }
            self.dismissKeyboard()
        }
        else {
            let anim = CAKeyframeAnimation(keyPath: "transform")
            anim.values = [
                NSValue(caTransform3D:CATransform3DMakeTranslation(-5, 0, 0)),
                NSValue(caTransform3D:CATransform3DMakeTranslation(5, 0, 0))
            ]
            anim.autoreverses = true
            anim.repeatCount = 2
            anim.duration = 10/100
            
            self.incorrectLabel.layer.add(anim, forKey: nil)
            self.incorrectLabel.text = "Please enter a valid email."
            self.incorrectLabel.isHidden = false
            
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
}
