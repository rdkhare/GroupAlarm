//
//  MainAlarmHandler.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/11/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit

class MainAlarmHandler: UIViewController, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var alarmName: String? = "Alarm"
    
    var alarms = [Alarm]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if(self.tableView.isEditing == true)
        {
            self.tableView.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Done"
            print("Edit Button tapped.")
        }
        else
        {
            self.tableView.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func unwindToAlarmController(_ segue: UIStoryboardSegue){
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! DisplayAlarmCell
        
        let row = indexPath.row
        let alarm = alarms[row]
        
        cell.alarmTitle.text = alarm.alarmLabel
        
//        print(alarmName)
        
        return cell
    }
    
}

