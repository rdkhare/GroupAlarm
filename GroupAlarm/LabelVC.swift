//
//  labelVC.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/11/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class LabelVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var labelText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    var setLabelText: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelText.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0)
        
        
        if(!(setLabelText == "Alarm")) {
            labelText.text = setLabelText
        }
        labelText.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var updatedTextString : NSString = labelText.text! as String as NSString
        updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
        
        self.updateTextLabels(withText: (updatedTextString) as String)
        
        if labelText.text?.characters.last == " "  && string == " "{
            
            labelText.endEditing(true)
            return false
        }
        
        return true
    }

    
    func updateTextLabels(withText string: String) {
        self.navigationItem.title = string
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToAlarmOptions" {
            
            let displayAlarmInfo = segue.destination as! AlarmInformation
            
            if(labelText.text?.isEmpty)! {
                labelText.text = "Alarm"
            }
            
            displayAlarmInfo.updateLabelText.text = labelText.text
        }
    }
    
}
