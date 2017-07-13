//
//  AddAlarm.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/11/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit

class AddEditAlarm: UITableViewController {
    
//    var alarm: Alarm?
// 
//    var addAlarms: [Alarm]? = nil
    
    @IBOutlet weak var updateLabelText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            
            let alarm = Alarm()
            alarm.alarmLabel = updateLabelText.text ?? ""
            
            let displayAlarms = segue.destination as! MainAlarmHandler
            
            displayAlarms.alarms.append(alarm)
            
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
