//
//  MainAlarmHandler.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/11/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import AVFoundation
import FirebaseDatabase
import Firebase

class DisplayAlarms: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    //    var daily: Bool? = false
    
    var dateA: Date?
    
    var weekdaysChecked = [String]()
    
    var alarms = [Alarm]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if(identifier == "displayAlarm") {
                
                let destinationNavigationController = segue.destination as! UINavigationController
                let targetController = destinationNavigationController.topViewController as! AddEditAlarm
                
                let alarmToSelect = alarms[(self.tableView.indexPathForSelectedRow?.row)!]
                
                print((self.tableView.indexPathForSelectedRow?.row)!)
                
                targetController.alarm = alarmToSelect
                
                self.tableView.reloadData()
                
                print("Table view cell tapped")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (didAllow, error) in
            
            if(error != nil) {
                print("User does not want notifications")
            }
            
        })
        
        var ref: DatabaseReference
        
        ref = Database.database().reference()
        
        let currentUserID = Auth.auth().currentUser?.uid
        
        var alarmIDValue: String?
        
        ref.child("users").child(currentUserID!).child("alarmID").observeSingleEvent(of: .value, with: { (snapshot) in
            //            let value = snapshot.value as? NSDictionary
            
            //            var alarmID: String?
            
            let alarmIDEnumerator = snapshot.children
            
            while let alarmIDs = alarmIDEnumerator.nextObject() as? DataSnapshot {
                print(alarmIDs.value!)
                
                
                //                alarmID = value?["alarmID"] as? String ?? " "
                
                print(snapshot)
                
                alarmIDValue = alarmIDs.value as! String?
                print(alarmIDValue!)
                
                ref.child("alarms").child(alarmIDValue!).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get alarm values for current user
                    let value = snapshot.value as? NSDictionary
                    let alarmtime = value?["alarmTime"] as? String ?? ""
                    let alarmlabel = value?["alarmLabel"] as? String ?? ""
                    //make alarm object and append to alarm
                    
                    
                    let alarm = Alarm.init(time: alarmtime, alarmLabel: alarmlabel)
                    
                    alarm.time = alarmtime
                    alarm.alarmLabel = alarmlabel
                    
                    
                    
                    
                    self.alarms.append(alarm)
                    
                    print(alarmtime)
                    print(alarmlabel)
                    
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            
        })
        
        //postRef.updateChildValues(dict)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
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
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"//"EE" to get short style
        let dayInWeek = dateFormatter.string(from: date)
        
        //only up to 40 alarms on free version lol
        if(alarms.count == 40) {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            tableView.reloadData()
        }
        
        let onColor  = UIColor(red: CGFloat(99.0/255.0), green: CGFloat(125.0 / 255.0), blue: CGFloat(219.0/255.0), alpha: CGFloat(1.0))
        
        //cell's alarm text and clock text
        cell.alarmTitle.text = alarm.alarmLabel
        cell.clockTitle.text = alarm.time
        cell.enableAlarm.onTintColor = onColor
        
        print(weekdaysChecked)
        
        
        //checkmarks in repeated days
        for weekdays in weekdaysChecked {
            
            if(dayInWeek == weekdays){
                let content = UNMutableNotificationContent()
                content.title = alarm.alarmLabel!
                content.body = alarm.time!
                content.sound = UNNotificationSound(named: "Spaceship_Alarm.mp3")
                let triggerTime = Calendar.current.dateComponents([.hour,.minute], from: dateA!)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: true)
                let identifier = "UYLLocalNotification"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
                
                print("This is the correct day.")
            }
        }
        
        if(dateA != nil) {
            if(weekdaysChecked.isEmpty) {
                let content = UNMutableNotificationContent()
                content.title = alarm.alarmLabel!
                content.body = alarm.time!
                content.sound = UNNotificationSound(named: "Spaceship_Alarm.mp3")
                let triggerTime = Calendar.current.dateComponents([.hour,.minute], from: dateA!)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: false)
                let identifier = "NeverNotification"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
        
        return cell
    }
    
    let firebase = Database.database().reference()
    
    func myDeleteFunction(childIWantToRemove: String) {
        let currentUserID = Auth.auth().currentUser?.uid
        
        
        firebase.child("users").child(currentUserID!).child("alarmID").child(childIWantToRemove).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.alarms.remove(at: indexPath.row)
            
            myDeleteFunction(childIWantToRemove: "\(indexPath.row)")
            
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}
