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
            
            let alarm = Alarm()
            
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = DateFormatter.Style.short
            
            timePicker.addTarget(self, action: Selector(("handler:")), for: UIControlEvents.valueChanged)

            let strDate: String? = timeFormatter.string(from: timePicker.date)
            
            print("\(strDate!) is the time!")
            
            alarm.time = strDate!
            
            alarm.alarmLabel = updateLabelText.text ?? ""
            
            let date = timePicker.date
            
            let displayAlarms = segue.destination as! MainAlarmHandler
            
            displayAlarms.dateA = date
            
            displayAlarms.alarms.append(alarm)
            
//            displayAlarms.daily = daily
            
            let userID = Auth.auth().currentUser?.uid
            let alarmRef = Database.database().reference().child("alarms").childByAutoId()
            
            let parameters: Any? = ["alarmLabel": updateLabelText.text!, "alarmTime": strDate!, "userID": userID!]
            
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
