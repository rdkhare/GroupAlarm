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

class AlarmInformation: UITableViewController {
    
    var alarm: Alarm?
    var addButtonPressed: Bool?
    var weekdaysRepeated: [String]?
    
    var alarmWeekdaysHolder: [String]?
    var keyArr : [String] = [String]()

    
    var repeatText = ""
    
    @IBOutlet weak var updateLabelText: UILabel!
    
    //    var daily: Bool? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(alarm?.daysToRepeat != nil) {
            
            
            if(alarm?.daysToRepeat.count == 0) {
                repeatText = "Never"
            }
                
            else if(alarm?.daysToRepeat.count == 7) {
                repeatText = "Everyday"
            }
                
            else if(alarm?.daysToRepeat[0] == "Monday" && alarm?.daysToRepeat[1] == "Tuesday" &&
                alarm?.daysToRepeat[2] == "Wednesday" && alarm?.daysToRepeat[3] == "Thursday"
                && alarm?.daysToRepeat[4] == "Friday") {
                
                print("Weekdays")
                repeatText = "Weekdays"
            }
                
            else if(alarm?.daysToRepeat[0] == "Sunday" && alarm?.daysToRepeat[(alarm?.daysToRepeat.count)! - 1] == "Saturday") {
                repeatText = "Weekends"
            }
            else {
                for day in (alarm?.daysToRepeat)! {
                    if(day == "Sunday") {
                        repeatText += "Sun "
                    }
                    if(day == "Monday") {
                        repeatText += "Mon "
                    }
                    if(day == "Tuesday") {
                        repeatText += "Tue "
                    }
                    if(day == "Wednesday") {
                        repeatText += "Wed "
                    }
                    if(day == "Thursday") {
                        repeatText += "Thu "
                    }
                    if(day == "Friday") {
                        repeatText += "Fri "
                    }
                    if(day == "Saturday") {
                        repeatText += "Sat "
                    }
                }
            }
        }
        else {
            repeatText = "Never"
        }
        
        weekdaysRepeated = alarm?.daysToRepeat ?? [String]()
        
        updateLabelText.text = alarm?.alarmLabel ?? "Alarm"
        
        repeatLabel.text = repeatText
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        
        if(alarm != nil) {
            
            let dateZ = dateFormatter.date(from: (alarm?.time)!)
            
            timePicker.setDate(dateZ!, animated: true)
            
        }
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        snoozeCell.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
    
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var snoozeCell: UITableViewCell!
    
    var newAlarmRef = Database.database().reference().child("alarms").childByAutoId()
    
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            
            
            let displayAlarms = segue.destination as! DisplayAlarms //unwind segue destination
            
            //somehow when clicking on the alarm, the data has not been written in firebase, and so when we enter the next viewcontroller, the key is not existing, thus forming a nil key value, I believe.
            
            if alarm != nil {
                print("There is already an alarm.")
                
                let key = alarm?.key
                
                if(key == nil) {
                    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                    let barButton = UIBarButtonItem(customView: activityIndicator)
                    self.navigationItem.setRightBarButton(barButton, animated: true)
                    activityIndicator.startAnimating()
                }
                else {
                    
                    let editAlarmRef = Database.database().reference().child("alarms").child(key!)
                    let timeFormatter = DateFormatter()
                    timeFormatter.timeStyle = DateFormatter.Style.short
                    
                    timePicker.addTarget(self, action: Selector(("handler:")), for: UIControlEvents.valueChanged)
                    
                    let strDate: String? = timeFormatter.string(from: timePicker.date)
                    print("\(strDate!) is the time!")
                    alarm?.time = strDate!
                    alarm?.alarmLabel = updateLabelText.text ?? ""
                    
                    self.tableView.reloadData()
                    
                    print("\(key!) is the alarm key")
                    //                var ref: DatabaseReference
                    //                ref = Database.database().reference()
                    let currentUserID = Auth.auth().currentUser?.uid //current user's id
                    
                    var userIDArr = [String]()

                    userIDArr.append(currentUserID!)
                    
                    editAlarmRef.updateChildValues(["alarmLabel": updateLabelText.text!, "alarmTime": strDate!, "userID": userIDArr, "repeatedDays": (alarm?.daysToRepeat)!])
                }
            }
            else{//if there is no alarm, add one
                
                print("\(String(describing: alarm))")
                print("There is not an alarm")
                
                let timeFormatter = DateFormatter()
                timeFormatter.timeStyle = DateFormatter.Style.short
                
                timePicker.addTarget(self, action: Selector(("handler:")), for: UIControlEvents.valueChanged)
                
                let strDate: String? = timeFormatter.string(from: timePicker.date)
                
                alarm?.time = strDate!
                alarm?.alarmLabel = updateLabelText.text ?? ""
                
                alarm = Alarm(time: strDate!, alarmLabel: updateLabelText.text!, daysToRepeat: alarmWeekdaysHolder ?? [String]())
                displayAlarms.alarms.append(alarm!)
                
                var userIDArr = [String]()
                
                let currentUserID = Auth.auth().currentUser?.uid
                
                userIDArr.append(currentUserID!)
                
                let parameters: Any? = ["alarmLabel": updateLabelText.text!, "alarmTime": strDate!, "userID": userIDArr, "repeatedDays": alarmWeekdaysHolder ?? "Never"]
                
                newAlarmRef.setValue(parameters)
                
                let key = newAlarmRef.key
                
                keyArr.append(key)
                
                print("\(keyArr) is the array of keys")
                
                var ref: DatabaseReference
                ref = Database.database().reference()
                let userRef = ref.child("users").child(currentUserID!)
                
                userRef.updateChildValues(["alarmID" : keyArr])
                //                print("\(key) is the user's alarm key")
                
            }
            
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = DateFormatter.Style.short
            //            let strDate: String? = timeFormatter.string(from: timePicker.date)
            let date = timePicker.date
            
            displayAlarms.dateA = date
            
            if(alarmWeekdaysHolder != nil) {
                displayAlarms.weekdaysChecked = alarmWeekdaysHolder!
            }
            
            print("Save Button pressed")
        }
        else if(segue.identifier == "cancel"){
            print("Cancel Button Pressed")
        }
        else if(segue.identifier == "showLabel") {
            let labelVC = segue.destination as! LabelVC
            
            if(!(updateLabelText.text?.isEmpty)!) {
                labelVC.setLabelText = updateLabelText.text
            }
            
        }
        else if(segue.identifier == "showRepeat") {
            let repeatVC = segue.destination as! RepeatVC

            repeatVC.weekdaysNotifChecked = (alarmWeekdaysHolder) ?? [String]()
            
            repeatVC.alarm = alarm
        }
    }
    
    
    
    
    @IBAction func unwindToEditAlarmSegue(_ segue: UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
