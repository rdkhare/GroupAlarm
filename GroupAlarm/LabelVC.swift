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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        labelText.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var updatedTextString : NSString = labelText.text! as String as NSString
        updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
        
        self.updateTextLabels(withText: (updatedTextString) as String)
        
        return true
    }

    
    func updateTextLabels(withText string: String) {
        self.navigationItem.title = string
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToAlarmOptions" {
            
            let displayAddEditAlarm = segue.destination as! AddEditAlarm
            
            displayAddEditAlarm.updateLabelText.text = labelText.text
        }
    }
    
}
