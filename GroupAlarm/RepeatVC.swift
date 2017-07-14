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
    
    
    
    var lastSelection: NSIndexPath!
    var repeatText = ""
    
    var checked: Bool? = false
    
    var weekdays: [Bool] = [false, false, false, false, false, false, false]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationItem.title = "Repeat"
    }
    
    
    @IBOutlet var repeatView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromRepeat" {
            
            if(weekdays[0] == true){
                repeatText += "Sun "
            }
            
            if(weekdays[1] == true){
                repeatText += "Mon "
            }
            
            if(weekdays[2] == true){
                repeatText += "Tue "
            }
            
            if(weekdays[3] == true){
                repeatText += "Wed "
            }
            
            if(weekdays[4] == true){
                repeatText += "Thu "
            }
            
            if(weekdays[5] == true){
                repeatText += "Fri "
            }
            
            if(weekdays[6] == true){
                repeatText += "Sat "
            }
            
            if(weekdays[0] == true && weekdays[1] == true && weekdays[2] == true && weekdays[3] == true
                && weekdays[4] == true && weekdays[5] == true && weekdays[6] == true){
                repeatText = "Daily"
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
            
            let displayAddEditAlarm = segue.destination as! AddEditAlarm
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
