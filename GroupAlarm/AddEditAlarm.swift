//
//  AddAlarm.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/11/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddEditAlarm: UITableViewController {
    
//    var alarm: Alarm?
// 
//    var addAlarms: [Alarm]? = nil
    
    @IBOutlet weak var updateLabelText: UILabel!
    
//    var daily: Bool? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        snoozeCell.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
    
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var snoozeCell: UITableViewCell!
    
    var weekdaysSelected = [String]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            
            
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = DateFormatter.Style.short
            
            timePicker.addTarget(self, action: Selector(("handler:")), for: UIControlEvents.valueChanged)

            let strDate: String? = timeFormatter.string(from: timePicker.date)
            
            let alarm = Alarm(time: strDate!, alarmLabel: updateLabelText.text!)
            
            print("\(strDate!) is the time!")
            
            alarm.time = strDate!
            alarm.alarmLabel = updateLabelText.text ?? ""
            
            let date = timePicker.date
            let displayAlarms = segue.destination as! DisplayAlarms
            
            displayAlarms.dateA = date
            displayAlarms.alarms.append(alarm)
            
            
//            displayAlarms.daily = daily
            
            var ref: DatabaseReference
            
            ref = Database.database().reference()
            
            let currentUserID = Auth.auth().currentUser?.uid
            let userRef = ref.child("users").child(currentUserID!)
            
            let alarmRef = Database.database().reference().child("alarms").childByAutoId()
            
            let key = alarmRef.key
            
            var alarmIDs = [Any]()
            
            alarmIDs.append(key)
            
            let alarmIDRef = userRef.child("alarmID")
//
            let childUpdates = ["\(displayAlarms.alarms.count - 1)" : key]
            
//            let childUpdate = ["alarmID" : key]
            
//            userRef.updateChildValues(alarmIDs)
            
            alarmIDRef.updateChildValues(childUpdates)
            
//            print(key)
            
            let parameters: Any? = ["alarmLabel": updateLabelText.text!, "alarmTime": strDate!, "userID": currentUserID]
            
            alarmRef.setValue(parameters)
            
            displayAlarms.weekdaysChecked = weekdaysSelected
            
            print("Save Button pressed")
        }
        else if(segue.identifier == "cancel"){
            print("Cancel Button Pressed")
        }
    }

    

    
    @IBAction func unwindToEditAlarmSegue(_ segue: UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
