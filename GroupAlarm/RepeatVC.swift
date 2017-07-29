//
//  repeatVC.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/11/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit


class RepeatVC: UITableViewController {
    
    
    @IBOutlet var repeatView: UITableView!
    
    var lastSelection: NSIndexPath!
    var repeatText = ""
    
    var checked: Bool? = false
    var alarm: Alarm?
    var weekdays: [Bool] = [false, false, false, false, false, false, false]
    
    var weekdaysNotifChecked = [String]()//loop through each day to check if it's today and then send the notification if so.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(alarm?.daysToRepeat != nil) {
            for days in (alarm?.daysToRepeat)! {
                if(days == "Sunday") {
                    print("Checkmark Sunday!")
                    self.repeatView.dequeueReusableCell(withIdentifier: "Sunday")?.accessoryType = UITableViewCellAccessoryType.checkmark
                }
                if(days == "Monday") {
                    print("Checkmark Monday!")
                    self.repeatView.dequeueReusableCell(withIdentifier: "Monday")?.accessoryType = UITableViewCellAccessoryType.checkmark
                }
                if(days == "Tuesday") {
                    print("Checkmark Tuesday!")
                    self.repeatView.dequeueReusableCell(withIdentifier: "Tuesday")?.accessoryType = UITableViewCellAccessoryType.checkmark
                }
                if(days == "Wednesday") {
                    print("Checkmark Wednesday!")
                    self.repeatView.dequeueReusableCell(withIdentifier: "Wednesday")?.accessoryType = UITableViewCellAccessoryType.checkmark
                }
                if(days == "Thursday") {
                    print("Checkmark Thursday!")
                    self.repeatView.dequeueReusableCell(withIdentifier: "Thursday")?.accessoryType = UITableViewCellAccessoryType.checkmark
                }
                if(days == "Friday") {
                    print("Checkmark Friday!")
                    self.repeatView.dequeueReusableCell(withIdentifier: "Friday")?.accessoryType = UITableViewCellAccessoryType.checkmark
                }
                if(days == "Saturday") {
                    print("Checkmark Saturday!")
                    self.repeatView.dequeueReusableCell(withIdentifier: "Saturday")?.accessoryType = UITableViewCellAccessoryType.checkmark
                }
            }
        }
        
        self.navigationItem.title = "Repeat"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromRepeat" {
            
            let displayAddEditAlarm = segue.destination as! AddEditAlarm
            
            if(weekdays[0] == true){
                repeatText += "Sun "
                weekdaysNotifChecked.append("Sunday")
            }
            
            if(weekdays[1] == true){
                repeatText += "Mon "
                weekdaysNotifChecked.append("Monday")
            }
            
            if(weekdays[2] == true){
                repeatText += "Tue "
                weekdaysNotifChecked.append("Tuesday")
            }
            
            if(weekdays[3] == true){
                repeatText += "Wed "
                weekdaysNotifChecked.append("Wednesday")
            }
            
            if(weekdays[4] == true){
                repeatText += "Thu "
                weekdaysNotifChecked.append("Thursday")
            }
            
            if(weekdays[5] == true){
                repeatText += "Fri "
                weekdaysNotifChecked.append("Friday")
            }
            
            if(weekdays[6] == true){
                repeatText += "Sat "
                weekdaysNotifChecked.append("Saturday")
            }
            
            if(weekdays[0] == true && weekdays[1] == true && weekdays[2] == true && weekdays[3] == true
                && weekdays[4] == true && weekdays[5] == true && weekdays[6] == true){
                repeatText = "Everyday"
                //                displayAddEditAlarm.daily = true
            }
                
            else if(weekdays[0] == true && weekdays[6] == true){
                repeatText = "Weekends"
            }
                
            else if(weekdays[1] == true && weekdays[2] == true && weekdays[3] == true
                && weekdays[4] == true && weekdays[5] == true){
                repeatText = "Weekdays"
            }
            else if(weekdays[0] == false && weekdays[1] == false && weekdays[2] == false && weekdays[3] == false
                && weekdays[4] == false && weekdays[5] == false && weekdays[6] == false){
                repeatText = "Never"
            }
            
            
            
            displayAddEditAlarm.weekdaysSelected = weekdaysNotifChecked
            
            displayAddEditAlarm.repeatLabel.text = repeatText
            print("\(repeatText) is my text")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            if(tableView.cellForRow(at: indexPath)?.tag == 0){
                weekdays[0] = false
            }
            if(tableView.cellForRow(at: indexPath)?.tag == 1){
                weekdays[1] = false
            }
            if(tableView.cellForRow(at: indexPath)?.tag == 2){
                weekdays[2] = false
            }
            if(tableView.cellForRow(at: indexPath)?.tag == 3){
                weekdays[3] = false
            }
            if(tableView.cellForRow(at: indexPath)?.tag == 4){
                weekdays[4] = false
            }
            if(tableView.cellForRow(at: indexPath)?.tag == 5){
                weekdays[5] = false
            }
            if(tableView.cellForRow(at: indexPath)?.tag == 6){
                weekdays[6] = false
            }
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            
            if(tableView.cellForRow(at: indexPath)?.tag == 0){
                weekdays[0] = true
            }
            if(tableView.cellForRow(at: indexPath)?.tag == 1){
                weekdays[1] = true
            }
            if(tableView.cellForRow(at: indexPath)?.tag == 2){
                weekdays[2] = true
            }
            if(tableView.cellForRow(at: indexPath)?.tag == 3){
                weekdays[3] = true
            }
            if(tableView.cellForRow(at: indexPath)?.tag == 4){
                weekdays[4] = true
            }
            if(tableView.cellForRow(at: indexPath)?.tag == 5){
                weekdays[5] = true
            }
            if(tableView.cellForRow(at: indexPath)?.tag == 6){
                weekdays[6] = true
            }
            print(weekdays)
            
        }
        
        
    }
    
    
    
}
