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
        
        self.navigationItem.title = "Repeat"
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.tintColor = UIColor.white
        
        if(alarm?.daysToRepeat != nil) {
            for days in (alarm?.daysToRepeat)! {
                if(days == "Sunday") {
                    if(cell.tag == 0) {
                        weekdays[0] = true
                        cell.accessoryType = UITableViewCellAccessoryType.checkmark
                    }
                }
                if(days == "Monday") {
//                    print("Checkmark Monday!")
                    if(cell.tag == 1) {
                        weekdays[1] = true
                        cell.accessoryType = UITableViewCellAccessoryType.checkmark
                    }
                }
                if(days == "Tuesday") {
//                    print("Checkmark Tuesday!")
                    if(cell.tag == 2) {
                        weekdays[2] = true
                        cell.accessoryType = UITableViewCellAccessoryType.checkmark
                    }
                }
                if(days == "Wednesday") {
//                    print("Checkmark Wednesday!")
                    if(cell.tag == 3) {
                        weekdays[3] = true
                        cell.accessoryType = UITableViewCellAccessoryType.checkmark
                    }
                }
                if(days == "Thursday") {
//                    print("Checkmark Thursday!")
                    if(cell.tag == 4) {
                        weekdays[4] = true
                        cell.accessoryType = UITableViewCellAccessoryType.checkmark
                    }
                }
                if(days == "Friday") {
//                    print("Checkmark Friday!")
                    if(cell.tag == 5) {
                        weekdays[5] = true
                        cell.accessoryType = UITableViewCellAccessoryType.checkmark
                    }
                }
                if(days == "Saturday") {
//                    print("Checkmark Saturday!")
                    if(cell.tag == 6) {
                        weekdays[6] = true
                        cell.accessoryType = UITableViewCellAccessoryType.checkmark
                    }
                }
            }
            
            
        }
        else {
            print("never")
        }

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromRepeat" {
            
            let displayAlarmInfo = segue.destination as! AlarmInformation
            
            if(weekdays[0] == true){
                repeatText += "Sun "
                if(!weekdaysNotifChecked.contains("Sunday")) {
                    weekdaysNotifChecked.append("Sunday")
                }
            }
            
            if(weekdays[1] == true){
                repeatText += "Mon "
                if(!weekdaysNotifChecked.contains("Monday")) {
                    weekdaysNotifChecked.append("Monday")
                }
            }
            
            if(weekdays[2] == true){
                repeatText += "Tue "
                if(!weekdaysNotifChecked.contains("Tuesday")) {
                    weekdaysNotifChecked.append("Tuesday")
                }
            }
            
            if(weekdays[3] == true){
                repeatText += "Wed "
                if(!weekdaysNotifChecked.contains("Wednesday")) {
                    weekdaysNotifChecked.append("Wednesday")
                }
            }
            
            if(weekdays[4] == true){
                repeatText += "Thu "
                if(!weekdaysNotifChecked.contains("Thursday")) {
                    weekdaysNotifChecked.append("Thursday")
                }
            }
            
            if(weekdays[5] == true){
                repeatText += "Fri "
                if(!weekdaysNotifChecked.contains("Friday")) {
                    weekdaysNotifChecked.append("Friday")
                }
            }
            
            if(weekdays[6] == true){
                repeatText += "Sat "
                if(!weekdaysNotifChecked.contains("Saturday")) {
                    weekdaysNotifChecked.append("Saturday")
                }
            }
            
            if(weekdays[0] == true && weekdays[1] == true && weekdays[2] == true && weekdays[3] == true
                && weekdays[4] == true && weekdays[5] == true && weekdays[6] == true){
                repeatText = "Everyday"
            }
                
            else if(weekdays[0] == true && weekdays[6] == true && weekdays[1] == false && weekdays[2] == false
                && weekdays[3] == false && weekdays[4] == false && weekdays[5] == false){
                repeatText = "Weekends"
            }
                
            else if(weekdays[1] == true && weekdays[2] == true && weekdays[3] == true
                && weekdays[4] == true && weekdays[5] == true && weekdays[6] == false && weekdays[0] == false){
                repeatText = "Weekdays"
            }
            else if(weekdays[0] == false && weekdays[1] == false && weekdays[2] == false && weekdays[3] == false
                && weekdays[4] == false && weekdays[5] == false && weekdays[6] == false){
                repeatText = "Never"
            }
            
            
            
            displayAlarmInfo.weekdaysSelected = weekdaysNotifChecked
            
            displayAlarmInfo.repeatLabel.text = repeatText
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
